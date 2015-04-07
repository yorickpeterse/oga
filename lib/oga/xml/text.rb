module Oga
  module XML
    ##
    # Class containing information about a single text node. Text nodes don't
    # have any children, attributes and the likes; just text.
    #
    class Text < CharacterNode
      def initialize(*args)
        super

        @decoded = false
      end

      ##
      # @param [String] value
      #
      def text=(value)
        @decoded = false
        @text    = value
      end

      ##
      # Returns the text as a String. Upon the first call any XML/HTML entities
      # are decoded.
      #
      # @return [String]
      #
      def text
        unless @decoded
          @text    = EntityDecoder.try_decode(@text, html?)
          @decoded = true
        end

        return @text
      end

      ##
      # @see [Oga::XML::CharacterNode#to_xml]
      #
      def to_xml
        node = parent

        if node.is_a?(Element) and html? \
        and Lexer::LITERAL_HTML_ELEMENTS.include?(node.name)
          return super
        end

        return Entities.encode(super)
      end
    end # Text
  end # XML
end # Oga
