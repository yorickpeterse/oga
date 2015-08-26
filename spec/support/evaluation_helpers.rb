module Oga
  module EvaluationHelpers
    ##
    # @param [Oga::XML::Document] document
    # @param [String] xpath
    # @return [Oga::XML::NodeSet]
    #
    def evaluate_xpath(document, xpath = self.class.description)
      ast      = parse_xpath(xpath)
      compiler = Oga::XPath::Compiler.new
      block    = compiler.compile(ast)

      block.call(document)
    end

    ##
    # Parses and evaluates a CSS expression.
    #
    # @param [Oga::XML::Document] document
    # @param [String] css
    # @return [Oga::XML::NodeSet]
    #
    def evaluate_css(document, css = self.class.description)
      ast      = parse_css(css)
      compiler = Oga::XPath::Compiler.new
      block    = compiler.compile(ast)

      block.call(document)
    end
  end # EvaluationHelpers
end # Oga
