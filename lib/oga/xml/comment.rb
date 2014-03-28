module Oga
  module XML
    ##
    #
    class Comment < Node
      attr_accessor :text

      def to_xml
        return "<!--#{text}-->"
      end
    end # Comment
  end # XML
end # Oga
