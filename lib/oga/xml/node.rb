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
      # Returns the parent node of the current node.
      #
      # @return [Oga::XML::Node]
      #
      def parent
        return node_set.owner
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
      # Generates the inspect value for the current node. Sub classes can
      # overwrite the {#extra_inspect_data} method to customize the output
      # format.
      #
      # @param [Fixnum] indent
      # @return [String]
      #
      def inspect(indent = 0)
        class_name = self.class.to_s.split('::').last
        spacing    = ' ' * indent

        return "#{spacing}#{class_name}(#{extra_inspect_data(indent)})"
      end

      ##
      # @return [String]
      #
      def extra_inspect_data; end

      ##
      # @return [Symbol]
      #
      def node_type
        return :node
      end
    end # Element
  end # XML
end # Oga
