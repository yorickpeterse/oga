%%machine lexer; # %

module Oga
  ##
  #
  class Lexer
    %% write data; # %

    attr_reader :html

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

    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value) if respond_to?(key)
      end

      reset
    end

    def reset
      @line     = 1
      @column   = 1
      @data     = nil
      @ts       = nil
      @te       = nil
      @tokens   = []
      @stack    = []
      @top      = 0
      @elements = []

      @string_buffer = ''
      @text_buffer   = ''
    end

    def lex(data)
      @data       = data
      lexer_start = self.class.lexer_start
      eof         = data.length

      %% write init;
      %% write exec;

      tokens = @tokens

      reset

      return tokens
    end

    def html?
      return !!html
    end

    private

    def advance_line(amount = 1)
      @line  += amount
      @column = 1
    end

    def advance_column(length = 1)
      @column += length
    end

    def t(type, start = @ts, stop = @te)
      value = text(start, stop)

      add_token(type, value)
    end

    def text(start = @ts, stop = @te)
      return @data[start...stop]
    end

    def add_token(type, value)
      token = [type, value, @line, @column]

      advance_column(value.length) if value

      @tokens << token
    end

    def emit_text_buffer
      return if @text_buffer.empty?

      add_token(:T_TEXT, @text_buffer)

      lines = @text_buffer.count("\n")

      advance_line(lines) if lines > 0

      @text_buffer = ''
    end

    def buffer_text_until_eof(eof)
      @text_buffer << text

      emit_text_buffer if @te == eof
    end

    def emit_string_buffer
      add_token(:T_STRING, @string_buffer)
      advance_column

      @string_buffer = ''
    end

    def current_element
      return @elements.last
    end

    %%{
      # Use instance variables for `ts` and friends.
      access @;

      newline    = '\n' | '\r\n';
      whitespace = [ \t];

      # Strings
      #
      # Strings in HTML can either be single or double quoted. If a string
      # starts with one of these quotes it must be closed with the same type of
      # quote.
      dquote = '"';
      squote = "'";

      action buffer_text {
        @text_buffer << text
      }

      action buffer_string {
        @string_buffer << text
      }

      action start_string_dquote {
        fcall string_dquote;
      }

      action start_string_squote {
        fcall string_squote;
      }

      # Machine for processing double quoted strings.
      string_dquote := |*
        ^dquote => buffer_string;
        dquote  => {
          emit_string_buffer
          advance_column
          fret;
        };
      *|;

      # Machine for processing single quoted strings.
      string_squote := |*
        ^squote => buffer_string;
        squote  => {
          emit_string_buffer
          advance_column
          fret;
        };
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
        emit_text_buffer
        t(:T_DOCTYPE_START)
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
        whitespace => { advance_column };

        '>' => {
          t(:T_DOCTYPE_END)
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
        emit_text_buffer
        t(:T_CDATA_START)
        fcall cdata;
      }

      # Machine that for processing the contents of CDATA tags. Everything
      # inside a CDATA tag is treated as plain text.
      cdata := |*
        cdata_end => {
          emit_text_buffer
          t(:T_CDATA_END)
          fret;
        };

        any => buffer_text;
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
        emit_text_buffer
        t(:T_COMMENT_START)
        fcall comment;
      }

      # Machine used for processing the contents of a comment. Everything
      # inside a comment is treated as plain text (similar to CDATA tags).
      comment := |*
        comment_end => {
          emit_text_buffer
          t(:T_COMMENT_END)
          fret;
        };

        any => buffer_text;
      *|;

      # Elements
      #
      # http://www.w3.org/TR/html-markup/syntax.html#syntax-elements
      #

      # Action that creates the tokens for the opening tag, name and namespace
      # (if any). Remaining work is delegated to a dedicated machine.
      action start_element {
        emit_text_buffer
        add_token(:T_ELEM_OPEN, nil)
        advance_column

        # Add the element name. If the name includes a namespace we'll break
        # the name up into two separate tokens.
        name = text(@ts + 1)

        if name.include?(':')
          ns, name = name.split(':')

          add_token(:T_ELEM_NS, ns)

          # Advance the column for the colon (:) that separates the namespace
          # and element name.
          advance_column
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
        (whitespace | '=') => { advance_column };

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
        element_start => start_element;
        doctype_start => start_doctype;
        cdata_start   => start_cdata;
        comment_start => start_comment;
        element_start => start_element;

        # Enter the body of the tag. If HTML mode is enabled and the current
        # element is a void element we'll close it and bail out.
        '>' => {
          if html? and HTML_VOID_ELEMENTS.include?(current_element)
            add_token(:T_ELEM_CLOSE, nil)
            @elements.pop
          end

          advance_column
        };

        # Regular closing tags.
        '</' element_name '>' => {
          emit_text_buffer
          add_token(:T_ELEM_CLOSE, nil)

          advance_column(@te - @ts)

          @elements.pop
        };

        # Self closing elements that are not handled by the HTML mode.
        '/>' => {
          advance_column
          add_token(:T_ELEM_CLOSE, nil)

          @elements.pop
        };

        # Note that this rule should be declared at the very bottom as it will
        # otherwise take precedence over the other rules.
        any => { buffer_text_until_eof(eof) };
      *|;
    }%%
  end # Lexer
end # Oga
