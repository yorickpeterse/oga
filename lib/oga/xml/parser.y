##
# DOM parser for both XML and HTML.
#
# This parser does not produce a dedicated AST, instead it emits XML nodes
# directly. Basic usage of this parser is as following:
#
#     parser   = Oga::XML::Parser.new('<foo></foo>')
#     document = parser.parse
#
# To enable HTML parsing you'd use the following instead:
#
#     parser   = Oga::XML::Parser.new('<foo></foo>', :html => true)
#     document = parser.parse
#
# In both cases you can use either a String or an IO as the parser input. IO
# instances will result in lower memory overhead, especially when parsing large
# files.
#
class Oga::XML::Parser

token T_TEXT T_STRING_SQUOTE T_STRING_DQUOTE T_STRING_BODY
token T_DOCTYPE_START T_DOCTYPE_END T_DOCTYPE_TYPE T_DOCTYPE_NAME
token T_DOCTYPE_INLINE
token T_CDATA T_COMMENT
token T_ELEM_START T_ELEM_NAME T_ELEM_NS T_ELEM_END T_ATTR T_ATTR_NS
token T_XML_DECL_START T_XML_DECL_END
token T_PROC_INS_START T_PROC_INS_NAME T_PROC_INS_END

options no_result_var

rule
  document
    : expressions { on_document(val[0]) }
    ;

  expressions
    : expressions_ { val[0] }
    | /* none */   { [] }
    ;

  expressions_
    : expressions_ expression { val[0] << val[1] }
    | expression              { val }
    ;

  expression
    : doctype
    | cdata
    | comment
    | element
    | text
    | xmldecl
    | proc_ins
    ;

  # Doctypes

  doctype
    # <!DOCTYPE html>
    : T_DOCTYPE_START T_DOCTYPE_NAME T_DOCTYPE_END
      {
        on_doctype(:name => val[1])
      }

    # <!DOCTYPE html PUBLIC>
    | T_DOCTYPE_START T_DOCTYPE_NAME T_DOCTYPE_TYPE T_DOCTYPE_END
      {
        on_doctype(:name => val[1], :type => val[2])
      }

    # <!DOCTYPE html PUBLIC "foo">
    | T_DOCTYPE_START T_DOCTYPE_NAME T_DOCTYPE_TYPE string T_DOCTYPE_END
      {
        on_doctype(:name => val[1], :type => val[2], :public_id => val[3])
      }

    # <!DOCTYPE html PUBLIC "foo" "bar">
    | T_DOCTYPE_START T_DOCTYPE_NAME T_DOCTYPE_TYPE string string T_DOCTYPE_END
      {
        on_doctype(
          :name      => val[1],
          :type      => val[2],
          :public_id => val[3],
          :system_id => val[4]
        )
      }

    # <!DOCTYPE html [ ... ]>
    | T_DOCTYPE_START T_DOCTYPE_NAME T_DOCTYPE_INLINE T_DOCTYPE_END
      {
        on_doctype(:name => val[1], :inline_rules => val[2])
      }
    ;

  # CDATA tags

  cdata
    # <![CDATA[foo]]>
    : T_CDATA { on_cdata(val[0]) }
    ;

  # Comments

  comment
    # <!-- foo -->
    : T_COMMENT { on_comment(val[0]) }
    ;

  # Processing Instructions

  proc_ins
    # <?xml?>
    : T_PROC_INS_START T_PROC_INS_NAME T_PROC_INS_END
      {
        on_proc_ins(val[1])
      }
    | T_PROC_INS_START T_PROC_INS_NAME T_TEXT T_PROC_INS_END
      {
        on_proc_ins(val[1], val[2])
      }
    ;

  # Elements

  element_open
    # <p>
    : T_ELEM_START T_ELEM_NAME { [nil, val[1]] }

    # <foo:p>
    | T_ELEM_START T_ELEM_NS T_ELEM_NAME { [val[1], val[2]] }
    ;

  element_start
    : element_open attributes { on_element(val[0][0], val[0][1], val[1]) }

  element
    : element_start expressions T_ELEM_END
      {
        if val[0]
          on_element_children(val[0], val[1])
        end

        after_element(val[0])
      }
    ;

  # Attributes

  attributes
    : attributes_ { val[0] }
    | /* none */  { [] }
    ;

  attributes_
    : attributes_ attribute { val[0] << val[1] }
    | attribute             { val }
    ;

  attribute
    # foo
    : attribute_name { val[0] }

    # foo="bar"
    | attribute_name string
      {
        val[0].value = val[1]
        val[0]
      }
    ;

  attribute_name
    # foo
    : T_ATTR { Attribute.new(:name => val[0]) }

    # foo:bar
    | T_ATTR_NS T_ATTR
      {
        Attribute.new(:namespace_name => val[0], :name => val[1])
      }
    ;

  # XML declarations

  xmldecl
    : T_XML_DECL_START attributes T_XML_DECL_END { on_xml_decl(val[1]) }
    ;

  # Plain text

  text
    : T_TEXT { on_text(val[0]) }
    ;

  string
    : string_dquote
    | string_squote
    ;

  # Single quoted strings
  string_dquote
    : T_STRING_DQUOTE T_STRING_DQUOTE             { '' }
    | T_STRING_DQUOTE string_body T_STRING_DQUOTE { val[1] }
    ;

  # Double quoted strings
  string_squote
    : T_STRING_SQUOTE T_STRING_SQUOTE             { '' }
    | T_STRING_SQUOTE string_body T_STRING_SQUOTE { val[1] }
    ;

  string_body
    : T_STRING_BODY             { val[0] }
    | string_body T_STRING_BODY { val[0] + val[1] }
    ;
end

---- inner
  ##
  # Hash mapping token types and dedicated error labels.
  #
  # @return [Hash]
  #
  TOKEN_ERROR_MAPPING = {
    'T_STRING'         => 'string',
    'T_TEXT'           => 'text',
    'T_DOCTYPE_START'  => 'doctype start',
    'T_DOCTYPE_END'    => 'doctype closing tag',
    'T_DOCTYPE_TYPE'   => 'doctype type',
    'T_DOCTYPE_NAME'   => 'doctype name',
    'T_DOCTYPE_INLINE' => 'inline doctype rules',
    'T_CDATA'          => 'CDATA',
    'T_COMMENT'        => 'comment',
    'T_ELEM_START'     => 'element start',
    'T_ELEM_NAME'      => 'element name',
    'T_ELEM_NS'        => 'element namespace',
    'T_ELEM_END'       => 'element closing tag',
    'T_ATTR'           => 'attribute',
    'T_ATTR_NS'        => 'attribute namespace',
    'T_XML_DECL_START' => 'XML declaration start',
    'T_XML_DECL_END'   => 'XML declaration end',
    'T_PROC_INS_START' => 'processing-instruction start',
    'T_PROC_INS_NAME'  => 'processing-instruction name',
    'T_PROC_INS_END'   => 'processing-instruction closing tag',
    '$end'             => 'end of input'
  }

  ##
  # @param [String|IO] data The input to parse.
  # @param [Hash] options
  # @see [Oga::XML::Lexer#initialize]
  #
  def initialize(data, options = {})
    @data  = data
    @lexer = Lexer.new(data, options)

    reset
  end

  ##
  # Resets the internal state of the parser.
  #
  def reset
    @line = 1

    @lexer.reset
  end

  ##
  # Yields the next token from the lexer.
  #
  # @yieldparam [Array]
  #
  def yield_next_token
    @lexer.advance do |type, value, line|
      @line = line if line

      yield [type, value]
    end

    yield [false, false]
  end

  ##
  # @param [Fixnum] type The type of token the error occured on.
  # @param [String] value The value of the token.
  # @param [Array] stack The current stack of parsed nodes.
  # @raise [Racc::ParseError]
  #
  def on_error(type, value, stack)
    name = token_to_str(type)
    name = TOKEN_ERROR_MAPPING[name] || name

    raise Racc::ParseError, "Unexpected #{name} on line #{@line}"
  end

  ##
  # Parses the input and returns the corresponding AST.
  #
  # @example
  #  parser = Oga::Parser.new('<foo>bar</foo>')
  #  ast    = parser.parse
  #
  # @return [Oga::AST::Node]
  #
  def parse
    ast = yyparse(self, :yield_next_token)

    reset

    return ast
  end

  ##
  # @param [Array] children
  # @return [Oga::XML::Document]
  #
  def on_document(children = [])
    document = Document.new(
      :type => @lexer.html ? :html : :xml
    )

    children.each do |child|
      if child.is_a?(Doctype)
        document.doctype = child

      elsif child.is_a?(XmlDeclaration)
        document.xml_declaration = child

      else
        document.children << child
      end
    end

    return document
  end

  ##
  # @param [Hash] options
  #
  def on_doctype(options = {})
    return Doctype.new(options)
  end

  ##
  # @param [String] text
  # @return [Oga::XML::Cdata]
  #
  def on_cdata(text = nil)
    return Cdata.new(:text => text)
  end

  ##
  # @param [String] text
  # @return [Oga::XML::Comment]
  #
  def on_comment(text = nil)
    return Comment.new(:text => text)
  end

  ##
  # @param [String] name
  # @param [String] text
  # @return [Oga::XML::ProcessingInstruction]
  #
  def on_proc_ins(name, text = nil)
    return ProcessingInstruction.new(:name => name, :text => text)
  end

  ##
  # @param [Array] attributes
  # @return [Oga::XML::XmlDeclaration]
  #
  def on_xml_decl(attributes = [])
    options = {}

    attributes.each do |attr|
      options[attr.name.to_sym] = attr.value
    end

    return XmlDeclaration.new(options)
  end

  ##
  # @param [String] text
  # @return [Oga::XML::Text]
  #
  def on_text(text)
    return Text.new(:text => text)
  end

  ##
  # @param [String] namespace
  # @param [String] name
  # @param [Hash] attributes
  # @return [Oga::XML::Element]
  #
  def on_element(namespace, name, attributes = {})
    element = Element.new(
      :namespace_name => namespace,
      :name           => name,
      :attributes     => attributes
    )

    return element
  end

  ##
  # @param [Oga::XML::Element] element
  # @param [Array] children
  # @return [Oga::XML::Element]
  #
  def on_element_children(element, children = [])
    element.children = children

    return element
  end

  ##
  # @param [Oga::XML::Element] element
  # @return [Oga::XML::Element]
  #
  def after_element(element)
    return element
  end

# vim: set ft=racc:
