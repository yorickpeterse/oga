module Oga
  module XML
    ##
    # Class containing information about a single text node. Text nodes don't
    # have any children, attributes and the likes; just text.
    #
    # @!attribute [rw] text
    #  @return [String]
    #
    class Text < Node
      attr_accessor :text

      ##
      # @return [String]
      #
      def to_xml
        return text.to_s
      end

      ##
      # @param [Fixnum] indent
      # @return [String]
      #
      def extra_inspect_data(indent)
        return "text: #{text.inspect}"
      end
    end # Text
  end # XML
end # Oga
