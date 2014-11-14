module Oga
  module XML
    ##
    # The Querying module provides methods that make it easy to run XPath/CSS
    # queries on XML documents/elements.
    #
    module Querying
      ##
      # Evaluates the given XPath expression.
      #
      # @param [String] expression The XPath expression to run.
      # @param [Hash] variables Variables to bind.
      # @see [Oga::XPath::Evaluator#initialize]
      #
      def xpath(expression, variables = {})
        return XPath::Evaluator.new(self, variables).evaluate(expression)
      end

      ##
      # Evaluates the given XPath expression and returns the first node in the
      # set.
      #
      # @see [#xpath]
      #
      def at_xpath(*args)
        result = xpath(*args)

        return result.is_a?(XML::NodeSet) ? result.first : result
      end

      ##
      # Evaluates the given CSS expression.
      #
      # @param [String] expression The CSS expression to run.
      # @see [Oga::XPath::Evaluator#initialize]
      #
      def css(expression)
        ast = CSS::Parser.new(expression).parse

        return XPath::Evaluator.new(self).evaluate_ast(ast)
      end

      ##
      # Evaluates the given CSS expression and returns the first node in the
      # set.
      #
      # @see [#css]
      #
      def at_css(*args)
        result = css(*args)

        return result.is_a?(XML::NodeSet) ? result.first : result
      end
    end # Querying
  end # XML
end # Oga
