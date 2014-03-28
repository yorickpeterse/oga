module Oga
  module XML
    ##
    #
    class Text < Node
      attr_accessor :text

      def to_xml
        return text.to_s
      end
    end # Text
  end # XML
end # Oga
