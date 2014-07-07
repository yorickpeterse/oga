module Oga
  module XPath
    ##
    # The Evaluator class is used to evaluate an XPath expression in the
    # context of a given document.
    #
    class Evaluator < AST::Processor
      ##
      # @param [Oga::XML::Document|Oga::XML::Node] document
      #
      def initialize(document)
        @document = document
        @cursor   = @document
      end

      def on_absolute(node)
        if @cursor.is_a?(XML::Node)
          @cursor = @cursor.root_node
        end

        return process_all(node.children)
      end

      def on_path(node)
        test, children = *node

        current = process(test)

        if current
          @cursor = current
          current = process(children)
        end

        return current
      end

      def on_test(node)
        nodes    = []
        ns, name = *node

        @cursor.children.each do |child|
          if child.is_a?(XML::Element) and child.name == name and child.namespace == ns
            nodes << child
          end
        end

        return nodes
      end
    end # Evaluator
  end # XPath
end # Oga
