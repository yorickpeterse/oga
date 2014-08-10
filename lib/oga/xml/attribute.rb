module Oga
  module XML
    ##
    # Class for storing information about a single XML attribute.
    #
    # @!attribute [rw] name
    #  The name of the attribute.
    #  @return [String]
    #
    # @!attribute [rw] namespace_name
    #  @return [String]
    #
    # @!attribute [rw] value
    #  The value of the attribute.
    #  @return [String]
    #
    # @!attribute [r] element
    #  The element this attribute belongs to.
    #  @return [Oga::XML::Element]
    #
    class Attribute
      attr_accessor :name, :namespace_name, :element, :value

      ##
      # @param [Hash] options
      #
      # @option options [String] :name
      # @option options [String] :namespace_name
      # @option options [String] :value
      # @option options [Oga::XML::Element] :element
      #
      def initialize(options = {})
        @name    = options[:name]
        @value   = options[:value]
        @element = options[:element]

        @namespace_name = options[:namespace_name]
      end

      ##
      # Returns the {Oga::XML::Namespace} instance for the current namespace
      # name.
      #
      # @return [Oga::XML::Namespace]
      #
      def namespace
        return @namespace ||= element.available_namespaces[namespace_name]
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
      def to_xml
        return %Q(#{name}="#{value}")
      end

      ##
      # @return [String]
      #
      def inspect
        segments = []

        [:name, :namespace, :value].each do |attr|
          value = send(attr)

          if value
            segments << "#{attr}: #{value.inspect}"
          end
        end

        return "Attribute(#{segments.join(' ')})"
      end
    end # Attribute
  end # XML
end # Oga
