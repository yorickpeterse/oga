%%machine lexer; # %

module Oga
  ##
  #
  class Lexer
    %% write data; # %

    # Lazy way of forwarding instance method calls used internally by Ragel to
    # their corresponding class methods.
    private_methods.grep(/^_lexer_/).each do |name|
      define_method(name) do
        return self.class.send(name)
      end

      private(name)
    end

    def initialize
      reset
    end

    def reset
      @line   = 1
      @column = 1
      @data   = nil
      @ts     = nil
      @te     = nil
      @tokens = []
      @stack  = []
      @top    = 0

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

    private

    def advance_line
      @line  += 1
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

      @text_buffer = ''
    end

    def emit_string_buffer
      add_token(:T_STRING, @string_buffer)
      advance_column

      @string_buffer = ''
    end

    %%{
      # Use instance variables for `ts` and friends.
      access @;

      newline    = '\n' | '\r\n';
      whitespace = [ \t];

      action emit_newline {
        t(:T_TEXT)
        advance_line
      }

      # String processing
      #
      # These actions/definitions can be used to process single and/or double
      # quoted strings (e.g. for tag attribute values).
      #
      # The string_dquote and string_squote machines should not be used
      # directly, instead the corresponding actions should be used.
      #
      dquote = '"';
      squote = "'";

      action buffer_text {
        @text_buffer << text
      }

      action buffer_string {
        @string_buffer << text
      }

      action string_dquote {
        fcall string_dquote;
      }

      action string_squote {
        fcall string_squote;
      }

      string_dquote := |*
        ^dquote => buffer_string;
        dquote  => {
          emit_string_buffer
          advance_column
          fret;
        };
      *|;

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

      doctype := |*
        'PUBLIC' | 'SYSTEM' => { t(:T_DOCTYPE_TYPE) };

        # Lex the public/system IDs as regular strings.
        dquote => string_dquote;
        squote => string_squote;

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
      element_name  = [a-zA-Z0-9\-_]+;
      element_start = '<' element_name;

      # First emit the token, then advance the column. This way the column
      # number points to the < and not the "p" in <p>.
      action open_element {
        t(:T_ELEM_OPEN, @ts + 1)

        advance_column

        fcall element;
      }

      element_text := |*
        ^'<' => buffer_text;

        '<' => {
          emit_text_buffer
          fhold;
          fret;
        };
      *|;

      element := |*
        whitespace => { advance_column };

        element_start => open_element;

        # Consume the text inside the element.
        '>' => {
          advance_column
          fcall element_text;
        };

        # Attributes and their values.
        element_name
          %{
            t(:T_ATTR, @ts, p)
            advance_column
          }
        '=' (dquote @string_dquote | squote @string_squote);

        # Non self-closing elements.
        '</' element_name {
          emit_text_buffer
          t(:T_ELEM_CLOSE, p)

          # Advance by two to take the closing </ into account. This is done
          # after emitting tokens to ensure that they point to the start of
          # the tag.
          advance_column(2)
          fret;
        };

        # self-closing / void elements.
        '/>' => {
          advance_column
          add_token(:T_ELEM_CLOSE, nil)
          fret;
        };
      *|;

      main := |*
        newline => emit_newline;

        doctype_start => {
          t(:T_DOCTYPE_START)
          fcall doctype;
        };

        cdata_start => {
          t(:T_CDATA_START)
          fcall cdata;
        };

        comment_start => {
          t(:T_COMMENT_START)
          fcall comment;
        };

        element_start => open_element;

        #dquote => { t(:T_DQUOTE) };
        #squote => { t(:T_SQUOTE) };
      *|;
    }%%
  end # Lexer
end # Oga
