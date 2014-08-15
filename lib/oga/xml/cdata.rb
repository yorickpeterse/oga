module Oga
  module XML
    ##
    # Class used for storing information about CDATA tags.
    #
    class Cdata < CharacterNode
      ##
      # Converts the node back to XML.
      #
      # @return [String]
      #
      def to_xml
        return "<![CDATA[#{text}]]>"
      end

      ##
      # @return [Symbol]
      #
      def node_type
        return :cdata
      end
    end # Cdata
  end # XML
end # Oga
