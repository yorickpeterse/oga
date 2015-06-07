module Oga
  module XML
    ##
    # Module for encoding/decoding XML and HTML entities. The mapping of HTML
    # entities can be found in {Oga::HTML::Entities::DECODE_MAPPING}.
    #
    module Entities
      ##
      # Hash containing XML entities and the corresponding characters.
      #
      # The `&amp;` mapping must come last to ensure proper conversion of non
      # encoded to encoded forms (see {Oga::XML::Text#to_xml}).
      #
      # @return [Hash]
      #
      DECODE_MAPPING = {
        '&lt;'   => '<',
        '&gt;'   => '>',
        '&apos;' => "'",
        '&quot;' => '"',
        '&amp;'  => '&',
      }

      ##
      # Hash containing characters and the corresponding XML entities.
      #
      # @return [Hash]
      #
      ENCODE_MAPPING = {
        '&' => '&amp;',
        '>' => '&gt;',
        '<' => '&lt;',
      }

      ##
      # @return [String]
      #
      AMPERSAND = '&'.freeze

      ##
      # Regexp for matching XML/HTML entities such as "&nbsp;".
      #
      # @return [Regexp]
      #
      REGULAR_ENTITY = /&\w+;/

      ##
      # Regexp for matching XML/HTML entities such as "&#38;".
      #
      # @return [Regexp]
      #
      CODEPOINT_ENTITY = /&#(x)?([a-zA-Z0-9]+);/

      ##
      # @return [Regexp]
      #
      ENCODE_REGEXP = Regexp.new(ENCODE_MAPPING.keys.join('|'))

      ##
      # Decodes XML entities.
      #
      # @param [String] input
      # @param [Hash] mapping
      # @return [String]
      #
      def self.decode(input, mapping = DECODE_MAPPING)
        return input unless input.include?(AMPERSAND)

        input = input.gsub(REGULAR_ENTITY, mapping)

        if input.include?(AMPERSAND)
          input = input.gsub(CODEPOINT_ENTITY) do |match|
            [$1 ? Integer($2, 16) : Integer($2, 10)].pack('U*')
          end
        end

        return input
      end

      ##
      # Encodes special characters as XML entities.
      #
      # @param [String] input
      # @param [Hash] mapping
      # @return [String]
      #
      def self.encode(input, mapping = ENCODE_MAPPING)
        return input.gsub(ENCODE_REGEXP, mapping)
      end
    end # Entities
  end # XML
end # Oga
