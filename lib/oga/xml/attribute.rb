module Oga
  module XML
    ##
    # Class for storing information about a single XML attribute.
    #
    # @!attribute [rw] name
    #  The name of the attribute.
    #  @return [String]
    #
    # @!attribute [rw] namespace
    #  The namespace of the attribute.
    #  @return [String]
    #
    # @!attribute [rw] value
    #  The value of the attribute.
    #  @return [String]
    #
    class Attribute
      attr_accessor :name, :namespace, :value

      ##
      # @param [Hash] options
      #
      # @option options [String] :name
      # @option options [String] :namespace
      # @option options [String] :value
      #
      def initialize(options = {})
        @name      = options[:name]
        @namespace = options[:namespace]
        @value     = options[:value]
      end

      ##
      # @return [String]
      #
      def to_s
        return value.to_s
      end

      ##
      # @return [String]
      #
      def inspect
        return "Attribute(name: #{name.inspect} " \
          "namespace: #{namespace.inspect} value: #{value.inspect})"
      end
    end # Attribute
  end # XML
end # Oga
