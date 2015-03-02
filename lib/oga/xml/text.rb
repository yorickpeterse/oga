module Oga
  module XML
    ##
    # Class containing information about a single text node. Text nodes don't
    # have any children, attributes and the likes; just text.
    #
    class Text < CharacterNode
      ##
      # @see [Oga::XML::CharacterNode#to_xml]
      #
      def to_xml
        node = parent
        root = root_node

        if root.is_a?(Document) and node.is_a?(Element) \
        and node.name == Lexer::SCRIPT_TAG and root.html?
          return super
        else
          return Entities.encode(super)
        end
      end
    end # Text
  end # XML
end # Oga
