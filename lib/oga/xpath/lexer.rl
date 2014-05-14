%%machine xpath_lexer; # %

module Oga
  module XPath
    ##
    # Ragel lexer for lexing XPath queries.
    #
    class Lexer
      %% write data;

      # % fix highlight

      ##
      # @param [String] data The data to lex.
      #
      def initialize(data)
        @data = data

        reset
      end

      ##
      # Resets the internal state of the lexer.
      #
      def reset

      end

      ##
      # Gathers all the tokens for the input and returns them as an Array.
      #
      # This method resets the internal state of the lexer after consuming the
      # input.
      #
      # @see [#advance]
      # @return [Array]
      #
      def lex
        tokens = []

        advance do |token|
          tokens << token
        end

        reset

        return tokens
      end

      ##
      # Advances through the input and generates the corresponding tokens. Each
      # token is yielded to the supplied block.
      #
      # Each token is an Array in the following format:
      #
      #     [TYPE, VALUE]
      #
      # The type is a symbol, the value is either nil or a String.
      #
      # This method stores the supplied block in `@block` and resets it after
      # the lexer loop has finished.
      #
      # This method does *not* reset the internal state of the lexer.
      #
      # @param [String] data The String to consume.
      # @return [Array]
      #
      def advance(&block)
        @block = block

        data  = @data # saves ivar lookups while lexing.
        ts    = nil
        te    = nil
        stack = []
        top   = 0
        cs    = self.class.xpath_lexer_start
        act   = 0
        eof   = @data.bytesize
        p     = 0
        pe    = eof

        #_xpath_lexer_eof_trans          = self.class.send(:_xpath_lexer_eof_trans)
        _xpath_lexer_from_state_actions = self.class.send(:_xpath_lexer_from_state_actions)
        _xpath_lexer_index_offsets      = self.class.send(:_xpath_lexer_index_offsets)
        _xpath_lexer_indicies           = self.class.send(:_xpath_lexer_indicies)
        _xpath_lexer_key_spans          = self.class.send(:_xpath_lexer_key_spans)
        _xpath_lexer_to_state_actions   = self.class.send(:_xpath_lexer_to_state_actions)
        _xpath_lexer_trans_actions      = self.class.send(:_xpath_lexer_trans_actions)
        _xpath_lexer_trans_keys         = self.class.send(:_xpath_lexer_trans_keys)
        _xpath_lexer_trans_targs        = self.class.send(:_xpath_lexer_trans_targs)

        %% write exec;

        # % fix highlight
      ensure
        @block = nil
      end

      private

      ##
      # Emits a token who's value is based on the supplied start/stop position.
      #
      # @param [Symbol] type The token type.
      # @param [Fixnum] start
      # @param [Fixnum] stop
      #
      # @see #text
      # @see #add_token
      #
      def emit(type, start, stop)
        value = text(start, stop)

        add_token(type, value)
      end

      ##
      # Returns the text of the current buffer based on the supplied start and
      # stop position.
      #
      # @param [Fixnum] start
      # @param [Fixnum] stop
      # @return [String]
      #
      def text(start, stop)
        return @data.byteslice(start, stop - start)
      end

      ##
      # Adds a token with the given type and value to the list.
      #
      # @param [Symbol] type The token type.
      # @param [String] value The token value.
      #
      def add_token(type, value = nil)
        token = [type, value, @line]

        @block.call(token)
      end

      %%{
        getkey (data.getbyte(p) || 0);

        main := |*
          any => { };
        *|;
      }%%
    end # Lexer
  end # XPath
end # Oga
