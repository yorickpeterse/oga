module Oga
  module XML
    ##
    # A generic XML node. Instances of this class can belong to a
    # {Oga::XML::NodeSet} and can be used to query surrounding and parent
    # nodes.
    #
    # @!attribute [rw] node_set
    #  @return [Oga::XML::NodeSet]
    #
    class Node
      attr_accessor :node_set

      ##
      # @param [Hash] options
      #
      # @option options [Oga::XML::NodeSet] :node_set The node set that this
      #  node belongs to.
      #
      # @option options [Oga::XML::NodeSet|Array] :children The child nodes of
      #  the current node.
      #
      def initialize(options = {})
        @node_set = options[:node_set]

        self.children = options[:children] if options[:children]
      end

      ##
      # Returns the child nodes of the current node.
      #
      # @return [Oga::XML::NodeSet]
      #
      def children
        return @children ||= NodeSet.new([], self)
      end

      ##
      # Sets the child nodes of the element.
      #
      # @param [Oga::XML::NodeSet|Array] nodes
      #
      def children=(nodes)
        if nodes.is_a?(NodeSet)
          @children = nodes
        else
          @children = NodeSet.new(nodes, self)
        end
      end

      ##
      # Returns the parent node of the current node. If there is no parent node
      # `nil` is returned instead.
      #
      # @return [Oga::XML::Node]
      #
      def parent
        return node_set ? node_set.owner : nil
      end

      ##
      # Returns the preceding node, or nil if there is none.
      #
      # @return [Oga::XML::Node]
      #
      def previous
        index = node_set.index(self) - 1

        return index >= 0 ? node_set[index] : nil
      end

      ##
      # Returns the following node, or nil if there is none.
      #
      # @return [Oga::XML::Node]
      #
      def next
        index  = node_set.index(self) + 1
        length = node_set.length

        return index <= length ? node_set[index] : nil
      end

      ##
      # Returns the previous element node or nil if there is none.
      #
      # @return [Oga::XML::Element]
      #
      def previous_element
        node = self

        while node = node.previous
          return node if node.is_a?(Element)
        end

        return
      end

      ##
      # Returns the next element node or nil if there is none.
      #
      # @return [Oga::XML::Element]
      #
      def next_element
        node = self

        while node = node.next
          return node if node.is_a?(Element)
        end

        return
      end

      ##
      # Returns the root document/node of the current node. The node is
      # retrieved by traversing upwards in the DOM tree from the current node.
      #
      # @return [Oga::XML::Document|Oga::XML::Node]
      #
      def root_node
        node = self

        loop do
          if !node.is_a?(Document) and node.node_set
            node = node.node_set.owner
          else
            break
          end
        end

        return node
      end

      ##
      # Removes the current node from the owning node set.
      #
      # @return [Oga::XML::Node]
      #
      def remove
        return node_set.delete(self) if node_set
      end

      ##
      # @return [Symbol]
      #
      def node_type
        return :node
      end
    end # Element
  end # XML
end # Oga
