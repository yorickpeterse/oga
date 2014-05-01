%%machine lexer; # %

module Oga
  module XML
    ##
    # Low level lexer that supports both XML and HTML (using an extra option).
    # To lex HTML input set the `:html` option to `true` when creating an
    # instance of the lexer:
    #
    #     lexer = Oga::XML::Lexer.new(:html => true)
    #
    # @!attribute [r] html
    #  @return [TrueClass|FalseClass]
    #
    # @!attribute [r] tokens
    #  @return [Array]
    #
    class Lexer
      %% write data;

      # % fix highlight

      attr_reader :html

      ##
      # Names of the HTML void elements that should be handled when HTML lexing
      # is enabled.
      #
      # @return [Set]
      #
      HTML_VOID_ELEMENTS = Set.new([
        'area',
        'base',
        'br',
        'col',
        'command',
        'embed',
        'hr',
        'img',
        'input',
        'keygen',
        'link',
        'meta',
        'param',
        'source',
        'track',
        'wbr'
      ])

      ##
      # @param [String] data The data to lex.
      #
      # @param [Hash] options
      #
      # @option options [Symbol] :html When set to `true` the lexer will treat
      # the input as HTML instead of SGML/XML. This makes it possible to lex
      # HTML void elements such as `<link href="">`.
      #
      def initialize(data, options = {})
        options.each do |key, value|
          instance_variable_set("@#{key}", value) if respond_to?(key)
        end

        @data = data

        reset
      end

      ##
      # Resets the internal state of the lexer. Typically you don't need to
      # call this method yourself as its called by #lex after lexing a given
      # String.
      #
      def reset
        @line     = 1
        @elements = []

        @buffer_start_position = nil
      end

      ##
      # Gathers all the tokens for the input and returns them as an Array.
      #
      # This method resets the internal state of the lexer after consuming the
      # input.
      #
      # @param [String] data The string to consume.
      # @return [Array]
      # @see #advance
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
      #
      # @param [String] data The String to consume.
      # @return [Array]
      #
      def advance(&block)
        @block = block

        data  = @data
        ts    = nil
        te    = nil
        stack = []
        top   = 0
        cs    = self.class.lexer_start
        act   = 0
        eof   = @data.bytesize
        p     = 0
        pe    = eof

        _lexer_eof_trans          = self.class.send(:_lexer_eof_trans)
        _lexer_from_state_actions = self.class.send(:_lexer_from_state_actions)
        _lexer_index_offsets      = self.class.send(:_lexer_index_offsets)
        _lexer_indicies           = self.class.send(:_lexer_indicies)
        _lexer_key_spans          = self.class.send(:_lexer_key_spans)
        _lexer_to_state_actions   = self.class.send(:_lexer_to_state_actions)
        _lexer_trans_actions      = self.class.send(:_lexer_trans_actions)
        _lexer_trans_keys         = self.class.send(:_lexer_trans_keys)
        _lexer_trans_targs        = self.class.send(:_lexer_trans_targs)

        %% write exec;

        # % fix highlight
      ensure
        @block = nil
      end

      ##
      # @return [TrueClass|FalseClass]
      #
      def html?
        return !!html
      end

      private

      ##
      # @param [Fixnum] amount The amount of lines to advance.
      #
      def advance_line(amount = 1)
        @line += amount
      end

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

      ##
      # Enables buffering starting at the given position.
      #
      # @param [Fixnum] position The start position of the buffer.
      #
      def start_buffer(position)
        @buffer_start_position = position
      end

      ##
      # Emits the current buffer if we have any. The current line number is
      # advanced based on the amount of newlines in the buffer.
      #
      # @param [Fixnum] position The end position of the buffer.
      # @param [Symbol] type The type of node to emit.
      #
      def emit_buffer(position, type = :T_TEXT)
        return unless @buffer_start_position

        content = text(@buffer_start_position, position)

        unless content.empty?
          add_token(type, content)

          lines = content.count("\n")

          advance_line(lines) if lines > 0
        end

        @buffer_start_position = nil
      end

      ##
      # Returns the name of the element we're currently in.
      #
      # @return [String]
      #
      def current_element
        return @elements.last
      end

      %%{
        getkey (data.getbyte(p) || 0);

        newline    = '\n' | '\r\n';
        whitespace = [ \t];
        identifier = [a-zA-Z0-9\-_:]+;

        # Strings
        #
        # Strings in HTML can either be single or double quoted. If a string
        # starts with one of these quotes it must be closed with the same type
        # of quote.
        dquote = '"';
        squote = "'";

        action start_string_dquote {
          start_buffer(te)

          fcall string_dquote;
        }

        action start_string_squote {
          start_buffer(te)

          fcall string_squote;
        }

        # Machine for processing double quoted strings.
        string_dquote := |*
          dquote => {
            emit_buffer(ts, :T_STRING)
            fret;
          };

          any;
        *|;

        # Machine for processing single quoted strings.
        string_squote := |*
          squote => {
            emit_buffer(ts, :T_STRING)
            fret;
          };

          any;
        *|;

        # DOCTYPES
        #
        # http://www.w3.org/TR/html-markup/syntax.html#doctype-syntax
        #
        # These rules support the 3 flavours of doctypes:
        #
        # 1. Normal doctypes, as introduced in the HTML5 specification.
        # 2. Deprecated doctypes, the more verbose ones used prior to HTML5.
        # 3. Legacy doctypes
        #
        doctype_start = '<!DOCTYPE'i whitespace+;

        action start_doctype {
          emit_buffer(ts)
          add_token(:T_DOCTYPE_START)
          fcall doctype;
        }

        # Machine for processing doctypes. Doctype values such as the public
        # and system IDs are treated as T_STRING tokens.
        doctype := |*
          'PUBLIC' | 'SYSTEM' => { emit(:T_DOCTYPE_TYPE, ts, te) };

          # Lex the public/system IDs as regular strings.
          dquote => start_string_dquote;
          squote => start_string_squote;

          # Whitespace inside doctypes is ignored since there's no point in
          # including it.
          whitespace;

          identifier => { emit(:T_DOCTYPE_NAME, ts, te) };

          '>' => {
            add_token(:T_DOCTYPE_END)
            fret;
          };
        *|;

        # CDATA
        #
        # http://www.w3.org/TR/html-markup/syntax.html#cdata-sections
        #
        # CDATA tags are broken up into 3 parts: the start, the content and the
        # end tag.
        #
        # In HTML CDATA tags have no meaning/are not supported. Oga does
        # support them but treats their contents as plain text.
        #
        cdata_start = '<![CDATA[';
        cdata_end   = ']]>';

        action start_cdata {
          emit_buffer(ts)
          add_token(:T_CDATA_START)

          start_buffer(te)

          fcall cdata;
        }

        # Machine that for processing the contents of CDATA tags. Everything
        # inside a CDATA tag is treated as plain text.
        cdata := |*
          cdata_end => {
            emit_buffer(ts)
            add_token(:T_CDATA_END)

            fret;
          };

          any;
        *|;

        # Comments
        #
        # http://www.w3.org/TR/html-markup/syntax.html#comments
        #
        # Comments are lexed into 3 parts: the start tag, the content and the
        # end tag.
        #
        # Unlike the W3 specification these rules *do* allow character
        # sequences such as `--` and `->`. Putting extra checks in for these
        # sequences would actually make the rules/actions more complex.
        #
        comment_start = '<!--';
        comment_end   = '-->';

        action start_comment {
          emit_buffer(ts)
          add_token(:T_COMMENT_START)

          start_buffer(te)

          fcall comment;
        }

        # Machine used for processing the contents of a comment. Everything
        # inside a comment is treated as plain text (similar to CDATA tags).
        comment := |*
          comment_end => {
            emit_buffer(ts)
            add_token(:T_COMMENT_END)

            fret;
          };

          any;
        *|;

        # XML declaration tags
        #
        # http://www.w3.org/TR/REC-xml/#sec-prolog-dtd
        #
        xml_decl_start = '<?xml';
        xml_decl_end   = '?>';

        action start_xml_decl {
          emit_buffer(ts)
          add_token(:T_XML_DECL_START)

          start_buffer(te)

          fcall xml_decl;
        }

        # Machine that processes the contents of an XML declaration tag.
        xml_decl := |*
          xml_decl_end => {
            emit_buffer(ts)
            add_token(:T_XML_DECL_END)

            fret;
          };

          # Attributes and their values (e.g. version="1.0").
          identifier => { emit(:T_ATTR, ts, te) };

          dquote => start_string_dquote;
          squote => start_string_squote;

          any;
        *|;

        # Elements
        #
        # http://www.w3.org/TR/html-markup/syntax.html#syntax-elements
        #

        # Action that creates the tokens for the opening tag, name and
        # namespace (if any). Remaining work is delegated to a dedicated
        # machine.
        action start_element {
          emit_buffer(ts)
          add_token(:T_ELEM_START)

          # Add the element name. If the name includes a namespace we'll break
          # the name up into two separate tokens.
          name = text(ts + 1, te)

          if name.include?(':')
            ns, name = name.split(':')

            add_token(:T_ELEM_NS, ns)
          end

          @elements << name if html?

          add_token(:T_ELEM_NAME, name)

          fcall element_head;
        }

        element_start = '<' identifier;

        # Machine used for processing the characters inside a element head. An
        # element head is everything between `<NAME` (where NAME is the element
        # name) and `>`.
        #
        # For example, in `<p foo="bar">` the element head is ` foo="bar"`.
        #
        element_head := |*
          whitespace | '=';

          newline => { advance_line };

          # Attribute names.
          identifier => { emit(:T_ATTR, ts, te) };

          # Attribute values.
          dquote => start_string_dquote;
          squote => start_string_squote;

          # The closing character of the open tag.
          ('>' | '/') => {
            fhold;
            fret;
          };
        *|;

        main := |*
          element_start  => start_element;
          doctype_start  => start_doctype;
          cdata_start    => start_cdata;
          comment_start  => start_comment;
          xml_decl_start => start_xml_decl;

          # Enter the body of the tag. If HTML mode is enabled and the current
          # element is a void element we'll close it and bail out.
          '>' => {
            if html? and HTML_VOID_ELEMENTS.include?(current_element)
              add_token(:T_ELEM_END, nil)
              @elements.pop
            end
          };

          # Regular closing tags.
          '</' identifier '>' => {
            emit_buffer(ts)
            add_token(:T_ELEM_END, nil)

            @elements.pop if html?
          };

          # Self closing elements that are not handled by the HTML mode.
          '/>' => {
            add_token(:T_ELEM_END, nil)

            @elements.pop if html?
          };

          # Note that this rule should be declared at the very bottom as it
          # will otherwise take precedence over the other rules.
          any => {
            # First character, start buffering (unless we already are buffering).
            start_buffer(ts) unless @buffer_start_position

            # EOF, emit the text buffer.
            if te == eof
              emit_buffer(te)
            end
          };
        *|;
      }%%
    end # Lexer
  end # XML
end # Oga
