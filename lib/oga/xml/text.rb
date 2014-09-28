module Oga
  module XML
    ##
    # Class containing information about a single text node. Text nodes don't
    # have any children, attributes and the likes; just text.
    #
    class Text < CharacterNode
      ##
      # @see [Oga::XML::CharacterNode#to_xml]
      #
      def to_xml
        return Entities.encode(super)
      end
    end # Text
  end # XML
end # Oga
