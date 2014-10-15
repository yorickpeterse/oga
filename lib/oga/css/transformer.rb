module Oga
  module CSS
    ##
    # Transforms an CSS AST into a corresponding XPath AST.
    #
    class Transformer < AST::Processor
      def on_class(node)
        name, test = node.to_a

        unless test
          test = s(:test, nil, '*')
        end

        predicate = s(
          :eq,
          s(:axis, 'attribute', s(:test, nil, 'class')),
          s(:string, name)
        )

        return s(:axis, 'child', test.updated(nil, test.children + [predicate]))
      end

      private

      def s(type, *children)
        return AST::Node.new(type, children)
      end
    end # Transformer
  end # CSS
end # Oga
