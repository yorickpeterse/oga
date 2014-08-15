module Oga
  module XML
    ##
    # Base class for nodes that represent a text-like value such as Text and
    # Comment nodes.
    #
    # @!attribute [rw] text
    #  @return [String]
    #
    class CharacterNode < Node
      attr_accessor :text

      ##
      # @param [Hash] options
      #
      # @option options [String] :text The text of the node.
      #
      def initialize(options = {})
        super

        @text = options[:text]
      end

      ##
      # @return [String]
      #
      def to_xml
        return text.to_s
      end

      ##
      # @return [String]
      #
      def inspect
        return "#{self.class.to_s.split('::').last}(#{text.inspect})"
      end
    end # CharacterNode
  end # XML
end # Oga
