module Oga
  module XML
    ##
    # Class for storing information about a single XML attribute.
    #
    class Attribute
      include ExpandedName

      # The name of the attribute.
      # @return [String]
      attr_accessor :name

      # @return [String]
      attr_accessor :namespace_name

      # The element this attribute belongs to.
      # @return [Oga::XML::Element]
      attr_accessor :element

      ##
      # The default namespace available to all attributes. This namespace can
      # not be modified.
      #
      # @return [Oga::XML::Namespace]
      #
      DEFAULT_NAMESPACE = Namespace.new(
        :name => 'xml',
        :uri  => XML::DEFAULT_NAMESPACE.uri
      ).freeze

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
        unless @namespace
          if namespace_name == DEFAULT_NAMESPACE.name
            @namespace = DEFAULT_NAMESPACE
          else
            @namespace = element.available_namespaces[namespace_name]
          end
        end

        @namespace
      end

      ##
      # @param [String] value
      #
      def value=(value)
        @value   = value
        @decoded = false
      end

      ##
      # Returns the value of the attribute or nil if no explicit value was set.
      #
      # @return [String|NilClass]
      #
      def value
        if !@decoded and @value
          @value   = EntityDecoder.try_decode(@value, html?)
          @decoded = true
        end

        @value
      end

      ##
      # @return [String]
      #
      def text
        value.to_s
      end

      alias_method :to_s, :text

      ##
      # @return [String]
      #
      def to_xml
        if namespace_name
          full_name = "#{namespace_name}:#{name}"
        else
          full_name = name
        end

        enc_value = value ? Entities.encode_attribute(value) : nil

        %Q(#{full_name}="#{enc_value}")
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

        "Attribute(#{segments.join(' ')})"
      end

      # @see [Oga::XML::Node#each_ancestor]
      def each_ancestor(&block)
        return unless element

        yield element

        element.each_ancestor(&block)
      end

      private

      ##
      # @return [TrueClass|FalseClass]
      #
      def html?
        !!@element && @element.html?
      end
    end # Attribute
  end # XML
end # Oga
