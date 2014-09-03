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
end # Oga
