module Oga
  module XML
    ##
    # A generic XML node. Instances of this class can belong to a
    # {Oga::XML::NodeSet} and can be used to query surrounding and parent
    # nodes.
    #
    class Node
      include Traversal

      # @return [Oga::XML::NodeSet]
      attr_reader :node_set

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
        self.node_set = options[:node_set]
        self.children = options[:children] if options[:children]
      end

      ##
      # @param [Oga::XML::NodeSet] set
      #
      def node_set=(set)
        @node_set  = set
        @root_node = nil
        @html_p    = nil
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
        unless @root_node
          node = self

          loop do
            if !node.is_a?(Document) and node.node_set
              node = node.node_set.owner
            else
              break
            end
          end

          @root_node = node
        end

        return @root_node
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
      # Inserts the given node before the current node.
      #
      # @param [Oga::XML::Node] other
      #
      def before(other)
        index = node_set.index(self)

        node_set.insert(index, other)
      end

      ##
      # Inserts the given node after the current node.
      #
      # @param [Oga::XML::Node] other
      #
      def after(other)
        index = node_set.index(self) + 1

        node_set.insert(index, other)
      end

      ##
      # @return [TrueClass|FalseClass]
      #
      def html?
        if @html_p.nil?
          root = root_node

          @html_p = root.is_a?(Document) && root.html?
        end

        return @html_p
      end

      ##
      # @return [TrueClass|FalseClass]
      #
      def xml?
        return !html?
      end
    end # Element
  end # XML
end # Oga
