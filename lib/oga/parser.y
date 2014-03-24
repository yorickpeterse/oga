##
# Low level AST parser that supports both XML and HTML.
#
# Note that this parser itself does not deal with special HTML void elements.
# It requires every tag to have a closing tag. As such you'll need to enable
# HTML parsing mode when parsing HTML. This can be done as following:
#
#     parser = Oga::Parser.new(:html => true)
#
class Oga::Parser

token T_STRING T_TEXT
token T_DOCTYPE_START T_DOCTYPE_END T_DOCTYPE_TYPE
token T_CDATA_START T_CDATA_END
token T_COMMENT_START T_COMMENT_END
token T_ELEM_START T_ELEM_NAME T_ELEM_NS T_ELEM_END T_ATTR

options no_result_var

rule
  document
    : expressions { s(:document, val[0]) }
    | /* none */  { s(:document) }
    ;

  expressions
    : expressions expression { val.compact }
    | expression             { val[0] }
    | /* none */             { nil }
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
    : element_open attributes expressions T_ELEM_END
      {
        s(:element, val[0], val[1], val[2])
      }
    ;

  element_open
    # <p>
    : T_ELEM_START T_ELEM_NAME { [nil, val[1]] }

    # <foo:p>
    | T_ELEM_START T_ELEM_NS T_ELEM_NAME { [val[1], val[2]] }
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
end

---- inner
  ##
  # @param [Hash] options
  #
  # @option options [TrueClass|FalseClass] :html Enables HTML parsing mode.
  # @see Oga::Lexer#initialize
  #
  def initialize(options = {})
    @lexer = Lexer.new(options)
  end

  ##
  # Resets the internal state of the parser.
  #
  def reset
    @lines = []
    @line  = 1
  end

  ##
  # Emits a new AST token.
  #
  # @param [Symbol] type
  # @param [Array] children
  #
  def s(type, *children)
    return AST::Node.new(
      type,
      children.flatten,
      :line => @line
    )
  end

  ##
  # Returns the next token from the lexer.
  #
  # @return [Array]
  #
  def next_token
    type, value, line = @tokens.shift

    @line = line if line

    return type ? [type, value] : [false, false]
  end

  ##
  # @param [Fixnum] type The type of token the error occured on.
  # @param [String] value The value of the token.
  # @param [Array] stack The current stack of parsed nodes.
  # @raise [Racc::ParseError]
  #
  def on_error(type, value, stack)
    name  = token_to_str(type)
    index = @line - 1
    lines = ''

    # Show up to 5 lines before and after the offending line (if they exist).
    (-5..5).each do |offset|
      line   = @lines[index + offset]
      number = @line + offset

      if line and number > 0
        if offset == 0
          prefix = '=> '
        else
          prefix = '   '
        end

        lines << "#{prefix}#{number}: #{line.strip}\n"
      end
    end

    raise Racc::ParseError, <<-EOF
Unexpected #{name} with value #{value.inspect} on line #{@line}:

#{lines}
    EOF
  end

  ##
  # Parses the supplied string and returns the AST.
  #
  # @example
  #  parser = Oga::Parser.new
  #  ast    = parser.parse('<foo>bar</foo>')
  #
  # @param [String] string
  # @return [Oga::AST::Node]
  #
  def parse(string)
    @lines  = string.lines
    @tokens = @lexer.lex(string)
    ast     = do_parse

    reset

    return ast
  end

# vim: set ft=racc:
