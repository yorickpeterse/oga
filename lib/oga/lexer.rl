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
      value = @data[start...stop]
      token = [type, value, @line, @column]

      advance_column(value.length)

      @tokens << token
    end

    %%{
      # Use instance variables for `ts` and friends.
      access @;

      newline    = '\n';
      whitespace = [ \t];

      any_escaped = /\\./;

      smaller     = '<';
      greater     = '>';
      slash       = '/';
      exclamation = '!';
      equals      = '=';
      colon       = ':';

      s_quote  = "'";
      d_quote  = '"';

      # FIXME: there really should be a better way of doing this.
      text = (any - s_quote - d_quote - equals - exclamation - slash -
        greater - smaller - whitespace - newline - colon)+;

      # Unicode characters, taken from whitequark's wonderful parser library.
      # (I honestly need to buy that dude a beer or 100). Basically this
      # takes all characters and removes ASCII ones from the list, thus
      # leaving you with Unicode.
      unicode = any - ascii;

      main := |*
        whitespace  => { t(:T_SPACE) };
        newline     => { t(:T_NEWLINE); advance_line };
        smaller     => { t(:T_SMALLER) };
        greater     => { t(:T_GREATER) };
        slash       => { t(:T_SLASH) };
        d_quote     => { t(:T_DQUOTE) };
        s_quote     => { t(:T_SQUOTE) };
        colon       => { t(:T_COLON) };
        exclamation => { t(:T_EXCLAMATION) };
        equals      => { t(:T_EQUALS) };
        text        => { t(:T_TEXT) };
      *|;
    }%%
  end # Lexer
end # Oga
