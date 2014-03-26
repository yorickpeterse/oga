module Oga
  module XML
    ##
    # Class for building a DOM tree of XML/HTML nodes.
    #
    # @!attribute [r] ast
    #  @return [Oga::AST::Node]
    #
    class Builder < ::AST::Processor
      attr_reader :ast

      ##
      # @param [Oga::AST::Node] ast
      #
      def initialize(ast)
        @ast = ast
      end

      def on_element(node)

      end

      def on_text(node)

      end
    end # Builder
  end # XML
end # Oga
