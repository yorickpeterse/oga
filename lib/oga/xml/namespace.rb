module Oga
  module XML
    ##
    # The Namespace class contains information about XML namespaces such as the
    # name and URI.
    #
    class Namespace
      attr_accessor :name

      ##
      # @param [Hash] options
      #
      # @option options [String] :name
      #
      def initialize(options = {})
        @name = options[:name]
      end

      ##
      # @return [String]
      #
      def to_s
        return name.to_s
      end

      ##
      # @return [String]
      #
      def inspect
        return "Namespace(name: #{name.inspect})"
      end
    end # Namespace
  end # XML
end # Oga
