module Oga
  module XML
    # The Querying module provides methods that make it easy to run XPath/CSS
    # queries on XML documents/elements.
    module Querying
      # Evaluates the given XPath expression.
      #
      # Querying a document:
      #
      #     document = Oga.parse_xml <<-EOF
      #     <people>
      #       <person age="25">Alice</person>
      #     </people>
      #     EOF
      #
      #     document.xpath('people/person')
      #
      # Querying an element:
      #
      #     element = document.at_xpath('people')
      #
      #     element.xpath('person')
      #
      # Using variable bindings:
      #
      #     document.xpath('people/person[@age = $age]', 'age' => 25)
      #
      # @param [String] expression The XPath expression to run.
      #
      # @param [Hash] variables Variables to bind. The keys of this Hash should
      #  be String values.
      #
      # @return [Oga::XML::NodeSet]
      def xpath(expression, variables = {})
        ast   = XPath::Parser.parse_with_cache(expression)
        block = XPath::Compiler.compile_with_cache(ast)

        block.call(self, variables)
      end

      # Evaluates the XPath expression and returns the first matched node.
      #
      # Querying a document:
      #
      #     document = Oga.parse_xml <<-EOF
      #     <people>
      #       <person age="25">Alice</person>
      #     </people>
      #     EOF
      #
      #     person = document.at_xpath('people/person')
      #
      #     person.class # => Oga::XML::Element
      #
      # @see [#xpath]
      # @return [Oga::XML::Node|Oga::XML::Attribute]
      def at_xpath(*args)
        result = xpath(*args)

        result.is_a?(XML::NodeSet) ? result.first : result
      end

      # Evaluates the given CSS expression.
      #
      # Querying a document:
      #
      #     document = Oga.parse_xml <<-EOF
      #     <people>
      #       <person age="25">Alice</person>
      #     </people>
      #     EOF
      #
      #     document.css('people person')
      #
      # @param [String] expression The CSS expression to run.
      # @return [Oga::XML::NodeSet]
      def css(expression)
        ast   = CSS::Parser.parse_with_cache(expression)
        block = XPath::Compiler.compile_with_cache(ast)

        block.call(self)
      end

      # Evaluates the CSS expression and returns the first matched node.
      #
      # @see [#css]
      # @return [Oga::XML::Node|Oga::XML::Attribute]
      def at_css(*args)
        result = css(*args)

        result.is_a?(XML::NodeSet) ? result.first : result
      end
    end # Querying
  end # XML
end # Oga
