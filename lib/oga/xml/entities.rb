module Oga
  module XML
    module Entities
      ##
      # Decodes XML entities.
      #
      # @param [String] input
      # @return [String]
      #
      def self.decode(input)
        if input.include?("&")
          coder = HTMLEntities.new
          input = coder.decode(input)
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
        coder = HTMLEntities.new
        return coder.encode(input)
      end
    end # Entities
  end # XML
end # Oga
