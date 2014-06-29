module Oga
  module XML
    ##
    # The NodeSet class contains a set of {Oga::XML::Node} instances that can
    # be queried and modified. Optionally NodeSet instances can take ownership
    # of a node (besides just containing it). This allows the nodes to query
    # their previous and next elements.
    #
    class NodeSet
      include Enumerable

      ##
      # @param [Array] nodes The nodes to add to the set.
      #
      def initialize(nodes = [])
        @nodes = nodes
      end

      ##
      # Yields the supplied block for every node.
      #
      # @yieldparam [Oga::XML::Node]
      #
      def each
        @nodes.each { |node| yield node }
      end

      ##
      # Returns the last node in the set.
      #
      # @return [Oga::XML::Node]
      #
      def last
        return @nodes[-1]
      end

      ##
      # Returns `true` if the set is empty.
      #
      # @return [TrueClass|FalseClass]
      #
      def empty?
        return @nodes.empty?
      end

      ##
      # Returns the amount of nodes in the set.
      #
      # @return [Fixnum]
      #
      def length
        return @nodes.length
      end

      alias_method :count, :length
      alias_method :size, :length

      ##
      # Returns the index of the given node.
      #
      # @param [Oga::XML::Node] node
      # @return [Fixnum]
      #
      def index(node)
        return @nodes.index(node)
      end

      ##
      # Pushes the node at the end of the set.
      #
      # @param [Oga::XML::Node] node
      #
      def push(node)
        @nodes << node
      end

      alias_method :<<, :push

      ##
      # Pushes the node at the start of the set.
      #
      # @param [Oga::XML::Node] node
      #
      def unshift(node)
        @nodes.unshift(node)
      end

      ##
      # Shifts a node from the start of the set.
      #
      # @return [Oga::XML::Node]
      #
      def shift
        return @nodes.shift
      end

      ##
      # Pops a node from the end of the set.
      #
      # @return [Oga::XML::Node]
      #
      def pop
        return @nodes.pop
      end

      ##
      # Returns the node for the given index.
      #
      # @param [Fixnum] index
      # @return [Oga::XML::Node]
      #
      def [](index)
        return @nodes[index]
      end

      ##
      # Removes the current nodes from their owning set. The nodes are *not*
      # removed from the current set.
      #
      # This method is intended to remove nodes from an XML document/node.
      #
      def remove
        @nodes.each do |node|
          node.node_set.delete(node)
          node.node_set = nil
        end
      end

      ##
      # Removes a node from the current set only.
      #
      def delete(node)
        @nodes.delete(node)
      end

      ##
      # Returns the values of the given attribute.
      #
      # @param [String|Symbol] name The name of the attribute.
      # @return [Array]
      #
      def attribute(name)
        values = []

        @nodes.each do |node|
          if node.respond_to?(:attribute)
            values << node.attribute(name)
          end
        end

        return values
      end

      alias_method :attr, :attribute

      ##
      # Returns the text of all nodes in the set.
      #
      # @return [String]
      #
      def text
        text = ''

        @nodes.each do |node|
          if node.respond_to?(:text)
            text << node.text
          end
        end

        return text
      end

      ##
      # Takes ownership of all the nodes in the current set.
      #
      def associate_nodes!
        @nodes.each do |node|
          node.node_set = self
        end
      end
    end # NodeSet
  end # XML
end # Oga
