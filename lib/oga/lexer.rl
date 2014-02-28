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

    %%{
      # Use instance variables for `ts` and friends.
      access @;

      newline    = '\n' | '\r\n';
      whitespace = [ \t];

      # DOCTYPES
      #
      # http://www.w3.org/TR/html-markup/syntax.html#doctype-syntax
      #
      # Doctypes are treated with some extra care on lexer level to make the
      # parser's life easier. If they were treated as regular text it would be
      # a pain to specify a proper doctype in Racc since it can't match on a
      # token's value (only on its type).
      #
      # Doctype parsing is also relaxed compared to the W3 specification. For
      # example, the specification defines 4 doctype formats each having
      # different rules. Because Oga doesn't really use the doctype for
      # anything we'll just slap all the formats into a single rule. Easy
      # enough.
      doctype = '<' whitespace* '!' whitespace* 'DOCTYPE'i whitespace*
        'HTML'i whitespace* any* '>';

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
        cdata_start => {
          t(:T_CDATA_START)

          @cdata_buffer = ''
        };

        cdata_end => {
          add_token(:T_TEXT, @cdata_buffer)
          @cdata_buffer = nil

          t(:T_CDATA_END)

          fgoto main;
        };

        # Consume everything else character by character and store it in a
        # separate buffer.
        any => { @cdata_buffer << text };
      *|;

      main := |*
        whitespace => { t(:T_SPACE) };
        newline    => { t(:T_NEWLINE); advance_line };

        doctype  => { t(:T_DOCTYPE) };

        # Jump to the cdata machine right away without processing anything.
        cdata_start >{ fhold; fgoto cdata; };

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
