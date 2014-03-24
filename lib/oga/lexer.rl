%%machine lexer; # %

module Oga
  ##
  # Low level lexer that supports both XML and HTML (using an extra option). To
  # lex HTML input set the `:html` option to `true` when creating an instance
  # of the lexer:
  #
  #     lexer = Oga::Lexer.new(:html => true)
  #
  # @!attribute [r] html
  #  @return [TrueClass|FalseClass]
  #
  class Lexer
    %% write data; # %

    attr_reader :html

    ##
    # Names of the HTML void elements that should be handled when HTML lexing
    # is enabled.
    #
    # @return [Array]
    #
    HTML_VOID_ELEMENTS = [
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
    ]

    # Lazy way of forwarding instance method calls used internally by Ragel to
    # their corresponding class methods.
    private_methods.grep(/^_lexer_/).each do |name|
      define_method(name) do
        return self.class.send(name)
      end

      private(name)
    end

    ##
    # @param [Hash] options
    #
    # @option options [Symbol] :html When set to `true` the lexer will treat
    #  the input as HTML instead of SGML/XML. This makes it possible to lex
    #  HTML void elements such as `<link href="">`.
    #
    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value) if respond_to?(key)
      end

      reset
    end

    ##
    # Resets the internal state of the lexer. Typically you don't need to call
    # this method yourself as its called by #lex after lexing a given String.
    #
    def reset
      @line     = 1
      @data     = nil
      @ts       = nil
      @te       = nil
      @tokens   = []
      @stack    = []
      @top      = 0
      @elements = []

      @buffer_start_position = nil
    end

    ##
    # Lexes the supplied String and returns an Array of tokens. Each token is
    # an Array in the following format:
    #
    #     [TYPE, VALUE]
    #
    # The type is a symbol, the value is either nil or a String.
    #
    # @param [String] data The string to lex.
    # @return [Array]
    #
    def lex(data)
      @data       = data.unpack('U*')
      lexer_start = self.class.lexer_start
      eof         = data.length

      %% write init;
      %% write exec;

      tokens = @tokens

      reset

      return tokens
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
    def t(type, start = @ts, stop = @te)
      value = text(start, stop)

      add_token(type, value)
    end

    ##
    # Returns the text of the current buffer based on the supplied start and
    # stop position.
    #
    # By default `@ts` and `@te` are used as the start/stop position.
    #
    # @param [Fixnum] start
    # @param [Fixnum] stop
    # @return [String]
    #
    def text(start = @ts, stop = @te)
      return @data[start...stop].pack('U*')
    end

    ##
    # Adds a token with the given type and value to the list.
    #
    # @param [Symbol] type The token type.
    # @param [String] value The token value.
    #
    def add_token(type, value)
      token = [type, value, @line]

      @tokens << token
    end

    ##
    # Enables buffering starting at the given position.
    #
    # @param [Fixnum] position The start position of the buffer, set to `@te`
    #  by default.
    #
    def start_buffer(position = @te)
      @buffer_start_position = position
    end

    ##
    # Returns `true` if we're currently buffering.
    #
    # @return [TrueClass|FalseClass]
    #
    def buffering?
      return !!@buffer_start_position
    end

    ##
    # Emits the current buffer if we have any. The current line number is
    # advanced based on the amount of newlines in the buffer.
    #
    # @param [Fixnum] position The end position of the buffer, set to `@ts` by
    #  default.
    #
    # @param [Symbol] type The type of node to emit.
    #
    def emit_buffer(position = @ts, type = :T_TEXT)
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
      # Use instance variables for `ts` and friends.
      access @;
      getkey (@data[p] || 0);

      newline    = '\n' | '\r\n';
      whitespace = [ \t];

      # Strings
      #
      # Strings in HTML can either be single or double quoted. If a string
      # starts with one of these quotes it must be closed with the same type of
      # quote.
      dquote = '"';
      squote = "'";

      action start_string_dquote {
        start_buffer

        fcall string_dquote;
      }

      action start_string_squote {
        start_buffer

        fcall string_squote;
      }

      # Machine for processing double quoted strings.
      string_dquote := |*
        dquote => {
          emit_buffer(@ts, :T_STRING)
          fret;
        };

        any;
      *|;

      # Machine for processing single quoted strings.
      string_squote := |*
        squote => {
          emit_buffer(@ts, :T_STRING)
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
      doctype_start = '<!DOCTYPE'i whitespace+ 'HTML'i;

      action start_doctype {
        emit_buffer
        add_token(:T_DOCTYPE_START, nil)
        fcall doctype;
      }

      # Machine for processing doctypes. Doctype values such as the public and
      # system IDs are treated as T_STRING tokens.
      doctype := |*
        'PUBLIC' | 'SYSTEM' => { t(:T_DOCTYPE_TYPE) };

        # Lex the public/system IDs as regular strings.
        dquote => start_string_dquote;
        squote => start_string_squote;

        # Whitespace inside doctypes is ignored since there's no point in
        # including it.
        whitespace;

        '>' => {
          add_token(:T_DOCTYPE_END, nil)
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
        emit_buffer
        t(:T_CDATA_START)

        start_buffer

        fcall cdata;
      }

      # Machine that for processing the contents of CDATA tags. Everything
      # inside a CDATA tag is treated as plain text.
      cdata := |*
        cdata_end => {
          emit_buffer
          t(:T_CDATA_END)

          fret;
        };

        any;
      *|;

      # Comments
      #
      # http://www.w3.org/TR/html-markup/syntax.html#comments
      #
      # Comments are lexed into 3 parts: the start tag, the content and the end
      # tag.
      #
      # Unlike the W3 specification these rules *do* allow character sequences
      # such as `--` and `->`. Putting extra checks in for these sequences
      # would actually make the rules/actions more complex.
      #
      comment_start = '<!--';
      comment_end   = '-->';

      action start_comment {
        emit_buffer
        t(:T_COMMENT_START)

        start_buffer

        fcall comment;
      }

      # Machine used for processing the contents of a comment. Everything
      # inside a comment is treated as plain text (similar to CDATA tags).
      comment := |*
        comment_end => {
          emit_buffer
          t(:T_COMMENT_END)

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
        emit_buffer
        add_token(:T_XML_DECL_START, nil)

        start_buffer

        fcall xml_decl;
      }

      # Machine that processes the contents of an XML declaration tag.
      xml_decl := |*
        xml_decl_end => {
          emit_buffer
          add_token(:T_XML_DECL_END, nil)

          fret;
        };

        any;
      *|;

      # Elements
      #
      # http://www.w3.org/TR/html-markup/syntax.html#syntax-elements
      #

      # Action that creates the tokens for the opening tag, name and namespace
      # (if any). Remaining work is delegated to a dedicated machine.
      action start_element {
        emit_buffer
        add_token(:T_ELEM_START, nil)

        # Add the element name. If the name includes a namespace we'll break
        # the name up into two separate tokens.
        name = text(@ts + 1)

        if name.include?(':')
          ns, name = name.split(':')

          add_token(:T_ELEM_NS, ns)
        end

        @elements << name

        add_token(:T_ELEM_NAME, name)

        fcall element_head;
      }

      element_name  = [a-zA-Z0-9\-_:]+;
      element_start = '<' element_name;

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
        element_name => { t(:T_ATTR) };

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
        '</' element_name '>' => {
          emit_buffer
          add_token(:T_ELEM_END, nil)

          @elements.pop
        };

        # Self closing elements that are not handled by the HTML mode.
        '/>' => {
          add_token(:T_ELEM_END, nil)

          @elements.pop
        };

        # Note that this rule should be declared at the very bottom as it will
        # otherwise take precedence over the other rules.
        any => {
          # First character, start buffering (unless we already are buffering).
          start_buffer(@ts) unless buffering?

          # EOF, emit the text buffer.
          if @te == eof
            emit_buffer(@te)
          end
        };
      *|;
    }%%
  end # Lexer
end # Oga
