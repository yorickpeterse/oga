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
        "<!--#{text}-->"
      end
    end # Comment
  end # XML
end # Oga
