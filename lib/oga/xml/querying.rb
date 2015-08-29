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
      #
      def xpath(expression, variables = {})
        ast   = XPath::Parser.parse_with_cache(expression)
        block = XPath::Compiler.compile_with_cache(ast)

        block.call(self, variables)
      end

      ##
      # Evaluates the given XPath expression and returns the first node in the
      # set.
      #
      # @see [#xpath]
      #
      def at_xpath(*args)
        result = xpath(*args)

        result.is_a?(XML::NodeSet) ? result.first : result
      end

      ##
      # Evaluates the given CSS expression.
      #
      # @param [String] expression The CSS expression to run.
      #
      def css(expression)
        ast   = CSS::Parser.parse_with_cache(expression)
        block = XPath::Compiler.compile_with_cache(ast)

        block.call(self)
      end

      ##
      # Evaluates the given CSS expression and returns the first node in the
      # set.
      #
      # @see [#css]
      #
      def at_css(*args)
        result = css(*args)

        result.is_a?(XML::NodeSet) ? result.first : result
      end
    end # Querying
  end # XML
end # Oga
