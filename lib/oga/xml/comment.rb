module Oga
  module XML
    ##
    # Class used for storing information about XML comments.
    #
    class Comment < CharacterNode
      ##
      # Converts the node back to XML.
      #
      # @return [String]
      #
      def to_xml
        return "<!--#{text}-->"
      end
      alias_method :to_html, :to_xml
    end # Comment
  end # XML
end # Oga
