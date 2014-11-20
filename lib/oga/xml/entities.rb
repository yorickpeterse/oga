require 'htmlentities'

module Oga
  module XML
    module Entities
      ##
      # @return [HTMLEntities]
      #
      CODER = HTMLEntities.new

      ##
      # Decodes XML entities.
      #
      # @param [String] input
      # @return [String]
      #
      def self.decode(input)
        return CODER.decode(input)
      end

      ##
      # Encodes special characters as XML entities.
      #
      # @param [String] input
      # @return [String]
      #
      def self.encode(input)
        return CODER.encode(input)
      end
    end # Entities
  end # XML
end # Oga
