class Oga::Parser

token T_SPACE T_NEWLINE T_SMALLER T_GREATER T_SLASH
token T_DQUOTE T_SQUOTE T_DASH T_RBRACKET T_LBRACKET
token T_COLON T_BANG T_EQUALS T_TEXT T_DOCTYPE

options no_result_var

rule
  document
    : expressions { s(:document, val[0]) }
    | /* none */  { s(:document) }
    ;

  expressions
    : expressions expression { val.compact }
    | expression             { val[0] }
    ;

  expression
    : tag
    | doctype
    ;

  # Doctypes

  doctype
    : T_DOCTYPE { s(:doctype, val[0]) }
    ;

  # Generic HTML tags

  tag_start
    # <p>
    : T_SMALLER T_TEXT T_GREATER { val[1] }
    ;

  tag_end
    # </p>
    : T_SMALLER T_SLASH T_TEXT T_GREATER
    ;

  tag
    # <p>foo</p>
    : tag_start tag_body tag_end
      {
        s(:element, val[0], val[1])
      }
    ;

  tag_body
    : T_TEXT
    ;

  whitespaces
    : whitespaces whitespace
    | whitespace
    ;

  whitespace
    : T_NEWLINE
    | T_SPACE
    ;
end

---- inner

  def initialize
    @lexer = Lexer.new
  end

  def reset
    @lines  = []
    @line   = 1
    @column = 1
  end

  def s(type, *children)
    return AST::Node.new(
      type,
      children.flatten,
      :line   => @line,
      :column => @column
    )
  end

  def next_token
    type, value, line, column = @tokens.shift

    @line   = line if line
    @column = column if column

    return type ? [type, value] : [false, false]
  end

  def on_error(type, value, stack)
    name      = token_to_str(type)
    line_str  = @lines[@line - 1]
    indicator = '~' * (@column - 1) + '^'

    raise Racc::ParseError, <<-EOF.strip
Failed to parse the supplied input.

Reason:   unexpected #{name} with value #{value.inspect}
Location: line #{@line}, column #{@column}

Offending code:

#{line_str}
#{indicator}

Current stack:

#{stack.inspect}
    EOF
  end

  def parse(string)
    @lines  = string.lines
    @tokens = @lexer.lex(string)
    ast     = do_parse

    reset

    return ast
  end

# vim: set ft=racc:
