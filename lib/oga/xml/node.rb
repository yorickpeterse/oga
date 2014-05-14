module Oga
  module XML
    ##
    # A single, generic XML node that can have a parent, next, previous and
    # child nodes.
    #
    # @!attribute [rw] parent
    #  @return [Oga::XML::Node]
    #
    # @!attribute [rw] children
    #  @return [Array<Oga::XML::Node>]
    #
    # @!attribute [rw] next
    #  @return [Oga::XML::Node]
    #
    # @!attribute [rw] previous
    #  @return [Oga::XML::Node]
    #
    class Node
      attr_accessor :parent, :children, :next, :previous

      ##
      # @param [Hash] options
      #
      # @option options [Array] :children The child nodes of the current
      #  element.
      #
      # @option options [Oga::XML::Node] :parent The parent node.
      # @option options [Oga::XML::Node] :next The following node.
      # @option options [Oga::XML::Node] :previous The previous node.
      #
      def initialize(options = {})
        @parent   = options[:parent]
        @children = options[:children] || []
        @next     = options[:next]
        @previous = options[:previous]
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
