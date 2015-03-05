module Oga
  module XML
    ##
    # Class containing information about a single text node. Text nodes don't
    # have any children, attributes and the likes; just text.
    #
    class Text < CharacterNode
      def initialize(*args)
        super

        @mutex   = Mutex.new
        @decoded = false
      end

      ##
      # @param [String] value
      #
      def text=(value)
        # In case of concurrent text/text= calls.
        @mutex.synchronize do
          @decoded = false
          @text    = value
        end
      end

      ##
      # Returns the text as a String. Upon the first call any XML/HTML entities
      # are decoded.
      #
      # @return [String]
      #
      def text
        @mutex.synchronize do
          unless @decoded
            decoder  = html? ? HTML::Entities : Entities
            @text    = decoder.decode(@text)
            @decoded = true
          end
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

      private

      ##
      # @return [TrueClass|FalseClass]
      #
      def html?
        root = root_node

        return root.is_a?(Document) && root.html?
      end
    end # Text
  end # XML
end # Oga
