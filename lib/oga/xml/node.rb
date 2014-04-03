module Oga
  module XML
    ##
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
        options.each do |key, value|
          instance_variable_set("@#{key}", value) if respond_to?(key)
        end

        @children ||= []

        after_initialize if respond_to?(:after_initialize)
      end
    end # Element
  end # XML
end # Oga
