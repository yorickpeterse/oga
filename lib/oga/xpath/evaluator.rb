module Oga
  module XPath
    ##
    # The Evaluator class is used to evaluate an XPath expression in the
    # context of a given document.
    #
    class Evaluator
      ##
      # @param [Oga::XML::Document|Oga::XML::Node] document
      #
      def initialize(document)
        @document = document
      end

      def evaluate(string)
        ast     = Parser.new(string).parse
        context = @document.children

        return process(ast, context)
      end

      def process(node, context)
        handler = "on_#{node.type}"

        return send(handler, node, context)
      end

      def on_absolute_path(node, context)
        if @document.respond_to?(:root_node)
          context = XML::NodeSet.new([@document.root_node])
        end

        return on_path(node, context)
      end

      def on_path(node, context)
        last_node = node.children[-1]
        nodes     = XML::NodeSet.new

        node.children.each do |test|
          nodes = process(test, context)

          if test != last_node and !nodes.empty?
            context = child_nodes(context)
          elsif nodes.empty?
            break
          end
        end

        return nodes
      end

      def on_test(node, context)
        ns, name = *node
        nodes    = XML::NodeSet.new

        context.each do |xml_node|
          next unless xml_node.is_a?(XML::Element)

          name_matches = xml_node.name == name || name == '*'
          ns_matches   = false

          if ns
            ns_matches = xml_node.namespace == ns || ns == '*'

          # If there's no namespace given but the name matches we'll also mark
          # the namespace as matching.
          elsif name_matches
            ns_matches = true
          end

          if name_matches and ns_matches
            nodes << xml_node
          end
        end

        return nodes
      end

      def child_nodes(nodes)
        children = XML::NodeSet.new

        nodes.each do |xml_node|
          xml_node.children.each do |child|
            children << child
          end
        end

        return children
      end
    end # Evaluator
  end # XPath
end # Oga
