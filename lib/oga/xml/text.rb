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
        if decode_entities?
          @text    = EntityDecoder.try_decode(@text, html?)
          @decoded = true
        end

        return @text
      end

      ##
      # @see [Oga::XML::CharacterNode#to_xml]
      #
      def to_xml
        return super if inside_literal_html?

        return Entities.encode(super)
      end

      private

      ##
      # @return [TrueClass|FalseClass]
      #
      def decode_entities?
        return !@decoded && !inside_literal_html?
      end

      ##
      # @return [TrueClass|FalseClass]
      #
      def inside_literal_html?
        node = parent

        return node.is_a?(Element) && html? &&
          Lexer::LITERAL_HTML_ELEMENTS.include?(node.name)
      end
    end # Text
  end # XML
end # Oga
