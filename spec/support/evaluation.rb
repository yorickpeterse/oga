module Oga
  module EvaluationHelpers
    ##
    # Parses and evaluates a CSS expression.
    #
    # @param [Oga::XML::Document] document
    # @param [String] css
    # @return [Oga::XML::NodeSet]
    #
    def evaluate_css(document, css)
      xpath = parse_css(css)

      return Oga::XPath::Evaluator.new(document).evaluate_ast(xpath)
    end
  end # EvaluationHelpers
end # Oga
