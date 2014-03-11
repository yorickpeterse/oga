class Oga::Parser

token T_NEWLINE T_SPACE
token T_STRING
token T_DOCTYPE_START T_DOCTYPE_END T_DOCTYPE_TYPE

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
    : doctype
    ;

  # Doctypes

  doctype
    # <!DOCTYPE html>
    : T_DOCTYPE_START T_DOCTYPE_END { s(:doctype) }

    # <!DOCTYPE html PUBLIC>
    | T_DOCTYPE_START T_DOCTYPE_TYPE T_DOCTYPE_END
      {
        s(:doctype, val[1])
      }

    # <!DOCTYPE html PUBLIC "foo">
    | T_DOCTYPE_START T_DOCTYPE_TYPE T_STRING T_DOCTYPE_END
      {
        s(:doctype, val[1], val[2])
      }

    # <!DOCTYPE html PUBLIC "foo" "bar">
    | T_DOCTYPE_START T_DOCTYPE_TYPE T_STRING T_STRING T_DOCTYPE_END
      {
        s(:doctype, val[1], val[2], val[3])
      }
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
