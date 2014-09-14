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
      alias_method :to_html, :to_xml
    end # Cdata
  end # XML
end # Oga
