module Oga
  module XML
    ##
    # Class used for storing information about a single processing instruction.
    #
    # @!attribute [rw] name
    #  @return [String]
    #
    class ProcessingInstruction < CharacterNode
      attr_accessor :name

      ##
      # @param [Hash] options
      #
      # @option options [String] :name The name of the instruction.
      # @see [Oga::XML::CharacterNode#initialize]
      #
      def initialize(options = {})
        super

        @name = options[:name]
      end

      ##
      # @return [String]
      #
      def to_xml
        return "<?#{name}#{text}?>"
      end

      ##
      # @return [String]
      #
      def inspect
        return "ProcessingInstruction(name: #{name.inspect} text: #{text.inspect})"
      end
    end # ProcessingInstruction
  end # XML
end # Oga
