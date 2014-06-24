module Oga
  module XML
    ##
    # The NodeSet class contains a set of {Oga::XML::Node} instances that can
    # be queried and modified.
    #
    class NodeSet
      include Enumerable

      def initialize(nodes = [])
        @nodes = nodes

        associate_nodes
      end

      def each
        @nodes.each { |node| yield node }
      end

      def length
        return @nodes.length
      end

      alias_method :size, :length

      def push(node)
        node.node_set = self
        node.index    = node.length

        @nodes << node
      end

      alias_method :<<, :push

      def attr(name)
        return @nodes.map { |node| node.attr(name) }
      end

      def remove
        @nodes.each do |node|
          # Remove references to the node from the parent node, if any.
          node.parent.children.delete!(node) if node.parent
        end
      end

      ##
      # Removes a node from the current set only.
      #
      def delete!(node)
        @nodes.delete(node)
      end

      def text
        text = ''

        @nodes.each do |node|
          text << node.text
        end

        return text
      end

      def associate_nodes
        @nodes.each_with_index do |node, index|
          node.node_set = self
          node.index    = index
        end
      end
    end # NodeSet
  end # XML
end # Oga
