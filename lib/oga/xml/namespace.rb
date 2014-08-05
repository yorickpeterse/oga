module Oga
  module XML
    ##
    # The Namespace class contains information about XML namespaces such as the
    # name and URI.
    #
    class Namespace
      attr_accessor :name, :uri

      ##
      # @param [Hash] options
      #
      # @option options [String] :name
      # @option options [String] :uri
      #
      def initialize(options = {})
        @name = options[:name]
        @uri  = options[:uri]
      end

      ##
      # @return [String]
      #
      def to_s
        return name.to_s
      end
    end # Namespace
  end # XML
end # Oga
