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

      advance_column(value.length)

      @tokens << token
    end

    def emit_text_buffer
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

      action emit_space {
        t(:T_SPACE)
      }

      action emit_newline {
        t(:T_NEWLINE)
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
        advance_column
        fcall string_dquote;
      }

      action string_squote {
        advance_column
        fcall string_squote;
      }

      string_dquote := |*
        ^dquote => buffer_string;
        dquote  => {
          emit_string_buffer
          fret;
        };
      *|;

      string_squote := |*
        ^squote => buffer_string;
        squote  => {
          emit_string_buffer
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
          fgoto main;
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

          fgoto main;
        };

        # Consume everything else character by character and store it in a
        # separate buffer.
        any => buffer_text;
      *|;

      main := |*
        whitespace => emit_space;
        newline    => emit_newline;

        doctype_start => {
          t(:T_DOCTYPE_START)

          fgoto doctype;
        };

        # @cdata_buffer is used to store the content of the CDATA tag.
        cdata_start => {
          t(:T_CDATA_START)

          fgoto cdata;
        };

        # General rules and actions.
        '<' => { t(:T_SMALLER) };
        '>' => { t(:T_GREATER) };
        '/' => { t(:T_SLASH) };
        '"' => { t(:T_DQUOTE) };
        "'" => { t(:T_SQUOTE) };
        '-' => { t(:T_DASH) };
        ']' => { t(:T_RBRACKET) };
        '[' => { t(:T_LBRACKET) };
        ':' => { t(:T_COLON) };
        '!' => { t(:T_BANG) };
        '=' => { t(:T_EQUALS) };
      *|;
    }%%
  end # Lexer
end # Oga
