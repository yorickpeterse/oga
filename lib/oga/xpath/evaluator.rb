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
      end

      def process(node, cursor)
        return if node.nil?

        node = node.to_ast

        on_handler = :"on_#{node.type}"

        if respond_to?(on_handler)
          new_node = send(on_handler, node, cursor)
        else
          new_node = handler_missing(node)
        end

        node = new_node if new_node

        return node
      end

      def process_all(nodes, cursor)
        return nodes.to_a.map do |node|
          process(node, cursor)
        end
      end

      def evaluate(string)
        ast    = Parser.new(string).parse
        cursor = move_cursor(@document)

        return process(ast, cursor)
      end

      def on_absolute(node, cursor)
        if @document.is_a?(XML::Node)
          cursor = move_cursor(@document.root_node)
        else
          cursor = move_cursor(@document)
        end

        return process_all(node.children, cursor)
      end

      def on_path(node, cursor)
        test, children = *node

        nodes = process(test, cursor)

        unless nodes.empty?
          nodes = process_all(children, nodes)
        end

        return nodes
      end

      def on_test(node, cursor)
        ns, name = *node
        nodes    = XML::NodeSet.new

        cursor.each do |xml_node|
          next unless xml_node.is_a?(XML::Element)

          if xml_node.name == name and xml_node.namespace == ns
            nodes << xml_node
          end
        end

        return nodes
      end

      def move_cursor(location)
        if location.is_a?(XML::Document)
          return location.children

        elsif location.is_a?(XML::Node)
          return XML::NodeSet.new([location])

        else
          return location
        end
      end
    end # Evaluator
  end # XPath
end # Oga
