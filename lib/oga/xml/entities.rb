module Oga
  module XML
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
        '&#60;'  => '<',
        '&gt;'   => '>',
        '&#62;'  => '>',
        '&apos;' => "'",
        '&#39;'  => "'",
        '&quot;' => '"',
        '&#34;'  => '"',
        '&amp;'  => '&',
        '&#38;'  => '&',
      }

      ##
      # Hash containing characters and the corresponding XML entities.
      #
      # @return [Hash]
      #
      ENCODE_MAPPING = {
        '&' => '&amp;',
        '"' => '&quot;',
        "'" => '&apos;',
        '>' => '&gt;',
        '<' => '&lt;',
      }

      ##
      # Decodes XML entities.
      #
      # @param [String] input
      # @return [String]
      #
      def self.decode(input)
        if input.include?('&')
          DECODE_MAPPING.each do |find, replace|
            input = input.gsub(find, replace)
          end
        end

        return input
      end

      ##
      # Encodes special characters as XML entities.
      #
      # @param [String] input
      # @return [String]
      #
      def self.encode(input)
        ENCODE_MAPPING.each do |from, to|
          input = input.gsub(from, to) if input.include?(from)
        end

        return input
      end
    end # Entities
  end # XML
end # Oga
