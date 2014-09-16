module Oga
  ##
  # Parses the given XML document.
  #
  # @example
  #  document = Oga.parse_xml('<root>Hello</root>')
  #
  # @param [String|IO] xml The XML input to parse.
  # @return [Oga::XML::Document]
  #
  def self.parse_xml(xml)
    return XML::Parser.new(xml).parse
  end

  ##
  # Parses the given HTML document.
  #
  # @example
  #  document = Oga.parse_html('<html>...</html>')
  #
  # @param [String|IO] html The HTML input to parse.
  # @return [Oga::XML::Document]
  #
  def self.parse_html(html)
    return HTML::Parser.new(html).parse
  end

  ##
  # Parses the given XML document using the SAX parser.
  #
  # @example
  #  handler = SomeSaxHandler.new
  #
  #  Oga.sax_parse_html(handler, '<root>Hello</root>')
  #
  # @param [Object] handler The SAX handler for the parser.
  # @param [String|IO] xml The XML to parse.
  #
  def self.sax_parse_xml(handler, xml)
    XML::SaxParser.new(handler, xml).parse
  end

  ##
  # Parses the given HTML document using the SAX parser.
  #
  # @example
  #  handler = SomeSaxHandler.new
  #
  #  Oga.sax_parse_html(handler, '<script>foo()</script>')
  #
  # @param [Object] handler The SAX handler for the parser.
  # @param [String|IO] HTML The HTML to parse.
  #
  def self.sax_parse_html(handler, html)
    HTML::SaxParser.new(handler, html).parse
  end
end # Oga
