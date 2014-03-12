class Oga::Parser

token T_NEWLINE T_SPACE
token T_STRING T_TEXT
token T_DOCTYPE_START T_DOCTYPE_END T_DOCTYPE_TYPE
token T_CDATA_START T_CDATA_END
token T_COMMENT_START T_COMMENT_END
token T_ELEM_OPEN T_ELEM_NAME T_ELEM_NS T_ELEM_CLOSE T_ATTR

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
    | cdata
    | comment
    | element
    | text
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

  # CDATA tags

  cdata
    # <![CDATA[]]>
    : T_CDATA_START T_CDATA_END { s(:cdata) }

    # <![CDATA[foo]]>
    | T_CDATA_START T_TEXT T_CDATA_END { s(:cdata, val[1]) }
    ;

  # Comments

  comment
    # <!---->
    : T_COMMENT_START T_COMMENT_END { s(:comment) }

    # <!-- foo -->
    | T_COMMENT_START T_TEXT T_COMMENT_END { s(:comment, val[1]) }
    ;

  # Elements

  element
    : element_open attributes element_body T_ELEM_CLOSE
      {
        s(:element, val[0], val[1], val[2])
      }
    ;

  element_open
    # <p>
    : T_ELEM_OPEN T_ELEM_NAME { [nil, val[1]] }

    # <foo:p>
    | T_ELEM_OPEN T_ELEM_NS T_ELEM_NAME { [val[1], val[2]] }
    ;

  element_body
    : text
    | element
    | /* none */ { nil }
    ;

  # Attributes

  attributes
    : attributes_ { s(:attributes, val[0]) }
    | /* none */  { nil }
    ;

  attributes_
    : attributes_ attribute { val }
    | attribute             { val }
    ;

  attribute
    # foo
    : T_ATTR { s(:attribute, val[0]) }

    # foo="bar"
    | T_ATTR T_STRING { s(:attribute, val[0], val[1]) }
    ;

  # Plain text

  text
    : T_TEXT { s(:text, val[0]) }
    ;

  # Whitespace

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
