%%machine css_lexer; # %

module Oga
  module CSS
    ##
    # Lexer for turning CSS expressions into a sequence of tokens. Tokens are
    # returned as arrays with every array having two values:
    #
    # 1. The token type as a Symbol
    # 2. The token value, or nil if there is no value.
    #
    # ## Thread Safety
    #
    # Similar to the XPath lexer this lexer keeps track of an internal state. As
    # a result it's not safe to share the same instance of this lexer between
    # multiple threads. However, no global state is used so you can use separate
    # instances in threads just fine.
    #
    class Lexer
      %% write data;

      # % fix highlight

      ##
      # @param [String] data The data to lex.
      #
      def initialize(data)
        @data = data
      end

      ##
      # Gathers all the tokens for the input and returns them as an Array.
      #
      # @see [#advance]
      # @return [Array]
      #
      def lex
        tokens = []

        advance do |type, value|
          tokens << [type, value]
        end

        return tokens
      end

      ##
      # Advances through the input and generates the corresponding tokens. Each
      # token is yielded to the supplied block.
      #
      # This method stores the supplied block in `@block` and resets it after
      # the lexer loop has finished.
      #
      # @see [#add_token]
      #
      def advance(&block)
        @block = block

        data  = @data # saves ivar lookups while lexing.
        ts    = nil
        te    = nil
        stack = []
        top   = 0
        cs    = self.class.css_lexer_start
        act   = 0
        eof   = @data.bytesize
        p     = 0
        pe    = eof

        _css_lexer_eof_trans          = self.class.send(:_css_lexer_eof_trans)
        _css_lexer_from_state_actions = self.class.send(:_css_lexer_from_state_actions)
        _css_lexer_index_offsets      = self.class.send(:_css_lexer_index_offsets)
        _css_lexer_indicies           = self.class.send(:_css_lexer_indicies)
        _css_lexer_key_spans          = self.class.send(:_css_lexer_key_spans)
        _css_lexer_to_state_actions   = self.class.send(:_css_lexer_to_state_actions)
        _css_lexer_trans_actions      = self.class.send(:_css_lexer_trans_actions)
        _css_lexer_trans_keys         = self.class.send(:_css_lexer_trans_keys)
        _css_lexer_trans_targs        = self.class.send(:_css_lexer_trans_targs)

        %% write exec;

        # % fix highlight
      ensure
        @block = nil
      end

      private

      ##
      # Emits a token of which the value is based on the supplied start/stop
      # position.
      #
      # @param [Symbol] type The token type.
      # @param [Fixnum] start
      # @param [Fixnum] stop
      #
      # @see [#text]
      # @see [#add_token]
      #
      def emit(type, start, stop)
        value = slice_input(start, stop)

        add_token(type, value)
      end

      ##
      # Returns the text between the specified start and stop position.
      #
      # @param [Fixnum] start
      # @param [Fixnum] stop
      # @return [String]
      #
      def slice_input(start, stop)
        return @data.byteslice(start, stop - start)
      end

      ##
      # Yields a new token to the supplied block.
      #
      # @param [Symbol] type The token type.
      # @param [String] value The token value.
      #
      # @yieldparam [Symbol] type
      # @yieldparam [String|NilClass] value
      #
      def add_token(type, value = nil)
        @block.call(type, value)
      end

      %%{
        getkey (data.getbyte(p) || 0);

        whitespace = [\t ]+;

        comma  = ',' %{ add_token(:T_COMMA) };
        hash   = '#' %{ add_token(:T_HASH) };
        dot    = '.' %{ add_token(:T_DOT) };
        lbrack = '[' %{ add_token(:T_LBRACK) };
        rbrack = ']' %{ add_token(:T_RBRACK) };
        colon  = ':' %{ add_token(:T_COLON) };
        lparen = '(' %{ add_token(:T_LPAREN) };
        rparen = ')' %{ add_token(:T_RPAREN) };
        pipe   = '|';

        # Identifiers
        #
        # Identifiers are used for element and attribute names. Identifiers have
        # to start with a letter.

        identifier = [a-zA-Z*]+ [a-zA-Z\-_0-9]*;

        action emit_identifier {
          emit(:T_IDENT, ts, te)
        }

        # Operators
        #
        # Various operators that can be used for filtering nodes. For example,
        # "$=" can be used to select attribute values that end with a given
        # string.
        #
        # http://www.w3.org/TR/css3-selectors/#selectors

        op_eq          = '=';
        op_space_in    = '~=';
        op_starts_with = '^=';
        op_ends_with   = '$=';
        op_in          = '*=';
        op_hyphen_in   = '|=';
        op_child       = '>';
        op_fol_direct  = '+';
        op_fol         = '~';

        # Numbers
        #
        # CSS selectors only understand integers, floating points are not
        # supported.

        integer = ('-' | '+')* digit+;

        action emit_integer {
          value = slice_input(ts, te).to_i

          add_token(:T_INT, value)
        }

        # Nth numbers
        #
        # These numbers are in the form of 2n+1 and are used for
        # pseudo-selectors such as nth-child(2n+1). The following parts such as
        # "-1" and "+1" are handled by the `integer` type and the corresponding
        # `emit_integer` action.

        nth_integer    = integer 'n';
        nth_identifier = '+n' | '-n';

        action emit_nth_integer {
          value = slice_input(ts, te - 1).to_i

          add_token(:T_INT, value)
          add_token(:T_NTH, 'n')
        }

        action emit_nth_identifier {
          emit(:T_NTH, ts, te)
        }

        main := |*
          whitespace | comma | hash | dot | lbrack | rbrack | colon;
          lparen | rparen;

          # Some of the operators have similar characters (e.g. the "="). As a
          # result we can't use rules like the following:
          #
          #     '='  %{ ... };
          #     '*=' %{ ... };
          #
          # This would result in both machines being executed for the input
          # "*=". The syntax below ensures that only the first match is handled.

          op_eq          => { add_token(:T_EQ) };
          op_space_in    => { add_token(:T_SPACE_IN) };
          op_starts_with => { add_token(:T_STARTS_WITH) };
          op_ends_with   => { add_token(:T_ENDS_WITH) };
          op_in          => { add_token(:T_IN) };
          op_hyphen_in   => { add_token(:T_HYPHEN_IN) };
          op_child       => { add_token(:T_CHILD) };
          op_fol_direct  => { add_token(:T_FOLLOWING_DIRECT) };
          op_fol         => { add_token(:T_FOLLOWING) };

          # The pipe character is also used in the |= operator so the action for
          # this is handled separately.
          pipe => { add_token(:T_PIPE) };

          identifier     => emit_identifier;
          nth_integer    => emit_nth_integer;
          nth_identifier => emit_nth_identifier;
          integer        => emit_integer;

          any;
        *|;
      }%%
    end # Lexer
  end # CSS
end # Oga
