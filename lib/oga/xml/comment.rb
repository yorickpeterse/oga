module Oga
  module XML
    ##
    # Class used for storing information about XML comments.
    #
    class Comment < Text
      ##
      # Converts the node back to XML.
      #
      # @return [String]
      #
      def to_xml
        return "<!--#{text}-->"
      end

      ##
      # @return [Symbol]
      #
      def node_type
        return :comment
      end
    end # Comment
  end # XML
end # Oga
