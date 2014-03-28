module Oga
  module XML
    ##
    #
    #
    class Cdata < Text
      def to_xml
        return "<![CDATA[#{text}]]>"
      end
    end # Cdata
  end # XML
end # Oga
