module Oga
  module XML
    ##
    # Class used for storing information about CDATA tags.
    #
    class Cdata < Text
      ##
      # Converts the node back to XML.
      #
      # @return [String]
      #
      def to_xml
        return "<![CDATA[#{text}]]>"
      end
    end # Cdata
  end # XML
end # Oga
