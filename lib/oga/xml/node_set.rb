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
      end

      def each
        @nodes.each { |node| yield node }
      end

      def length
        return @nodes.length
      end

      alias_method :size, :length

      def index(node)
        return @nodes.index(node)
      end

      def push(node)
        node.node_set = self

        @nodes << node
      end

      alias_method :<<, :push

      def attr(name)
        return @nodes.map { |node| node.attr(name) }
      end

      def remove
        @nodes.each do |node|
          node.node_set.delete!(node)
          node.node_set = nil
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
        end
      end
    end # NodeSet
  end # XML
end # Oga
