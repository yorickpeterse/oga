module Oga
  module XML
    ##
    # @!attribute [r] parent
    #  @return [Oga::XML::Node]
    #
    # @!attribute [r] children
    #  @return [Array<Oga::XML::Node>]
    #
    # @!attribute [r] next
    #  @return [Oga::XML::NOde]
    #
    # @!attribute [r] previous
    #  @return [Oga::XML::Node]
    #
    class Node
      attr_reader :parent, :children, :next, :previous

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
      end
    end # Element
  end # XML
end # Oga
