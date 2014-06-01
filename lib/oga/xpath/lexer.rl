%%machine xpath_lexer; # %

module Oga
  module XPath
    ##
    # Ragel lexer for lexing XPath queries.
    #
    class Lexer
      %% write data;

      # % fix highlight

      AXIS_MAPPING = {
        '@'  => 'attribute',
        '//' => 'descendant-or-self',
        '..' => 'parent',
        '.'  => 'self'
      }

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

        advance do |type, value|
          tokens << [type, value]
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

        _xpath_lexer_eof_trans          = self.class.send(:_xpath_lexer_eof_trans)
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
      # Emits a token of which the value is based on the supplied start/stop
      # position.
      #
      # @param [Symbol] type The token type.
      # @param [Fixnum] start
      # @param [Fixnum] stop
      #
      # @see #text
      # @see #add_token
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
      # Adds a token with the given type and value to the list.
      #
      # @param [Symbol] type The token type.
      # @param [String] value The token value.
      #
      def add_token(type, value = nil)
        @block.call(type, value)
      end

      %%{
        getkey (data.getbyte(p) || 0);

        whitespace = [\n\t ];

        slash  = '/' @{ add_token(:T_SLASH) };
        lparen = '(' @{ add_token(:T_LPAREN) };
        rparen = ')' @{ add_token(:T_RPAREN) };
        comma  = ',' @{ add_token(:T_COMMA) };
        colon  = ':' @{ add_token(:T_COLON) };

        # Identifiers
        #
        # Identifiers are used for element names, namespaces, attribute names,
        # etc. Identifiers have to start with a letter.

        identifier = [a-zA-Z]+ [a-zA-Z\-_0-9]*;

        action emit_identifier {
          emit(:T_IDENT, ts, te)
        }

        # Numbers
        #
        # XPath expressions can contain both integers and floats. The W3
        # specification treats these both as the same type of number. Oga
        # instead lexes them separately so that we can convert the values to
        # the corresponding Ruby types (Fixnum and Float).

        integer = digit+;
        float   = digit+ ('.' digit+)*;

        action emit_integer {
          value = slice_input(ts, te).to_i

          add_token(:T_INT, value)
        }

        action emit_float {
          value = slice_input(ts, te).to_f

          add_token(:T_FLOAT, value)
        }

        # Strings
        #
        # Strings can be single or double quoted. They are mainly used for
        # attribute values.
        #
        dquote = '"';
        squote = "'";

        string_dquote = (dquote ^dquote+ dquote);
        string_squote = (squote ^squote+ squote);

        string = string_dquote | string_squote;

        action emit_string {
          emit(:T_STRING, ts + 1, te - 1)
        }

        # Full Axes
        #
        # XPath axes in their full syntax.
        #
        axis_full = ('ancestor'
          | 'ancestor-or-self'
          | 'attribute'
          | 'child'
          | 'descendant'
          | 'descendant-or-self'
          | 'following'
          | 'following-sibling'
          | 'namespace'
          | 'parent'
          | 'preceding'
          | 'preceding-sibling'
          | 'self') '::';

        action emit_axis_full {
          emit(:T_AXIS, ts, te - 2)
        }

        # Short Axes
        #
        # XPath axes in their abbreviated form. When lexing these are mapped to
        # their full forms so that the parser doesn't have to take care of
        # this.
        #
        axis_short = '@' | '//' | '..' | '.';

        action emit_axis_short {
          value = AXIS_MAPPING[slice_input(ts, te)]

          add_token(:T_AXIS, value)
        }

        # Operators
        #
        # Operators can only be used inside predicates due to "div" and "mod"
        # conflicting with the patterns used for matching identifiers (=
        # element names and the likes).

        operator = '|'
          | 'and'
          | 'or'
          | '+'
          | '-'
          | '*'
          | 'div'
          | 'mod'
          | '='
          | '!='
          | '<'
          | '>'
          | '<='
          | '>=';

        action emit_operator {
          emit(:T_OP, ts, te)
        }

        # Machine that handles the lexing of data inside an XPath predicate.
        # When bumping into a "]" the lexer jumps back to the `main` machine.
        predicate := |*
          whitespace | slash | lparen | rparen | comma | colon;

          string     => emit_string;
          integer    => emit_integer;
          float      => emit_float;
          axis_full  => emit_axis_full;
          axis_short => emit_axis_short;
          operator   => emit_operator;
          identifier => emit_identifier;

          ']' => {
            add_token(:T_RBRACK)
            fnext main;
          };
        *|;

        main := |*
          whitespace | slash | lparen | rparen | comma | colon;

          '[' => {
            add_token(:T_LBRACK)
            fnext predicate;
          };

          axis_full  => emit_axis_full;
          axis_short => emit_axis_short;
          identifier => emit_identifier;
        *|;
      }%%
    end # Lexer
  end # XPath
end # Oga
