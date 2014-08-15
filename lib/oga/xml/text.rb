module Oga
  module XML
    ##
    # Class containing information about a single text node. Text nodes don't
    # have any children, attributes and the likes; just text.
    #
    class Text < CharacterNode
      ##
      # @return [Symbol]
      #
      def node_type
        return :text
      end
    end # Text
  end # XML
end # Oga
