module Oga
  module XML
    ##
    #
    class Text < Node
      attr_accessor :text

      def to_xml
        return text.to_s
      end

      def extra_inspect_data(indent)
        return "text: #{text.inspect}"
      end
    end # Text
  end # XML
end # Oga
