module Oga
  module XML
    ##
    # Class that contains information about an XML element such as the name,
    # attributes and child nodes.
    #
    # @!attribute [rw] name
    #  The name of the element.
    #  @return [String]
    #
    # @!attribute [rw] namespace
    #  The namespace of the element, if any.
    #  @return [String]
    #
    # @!attribute [rw] attributes
    #  The attributes of the element.
    #  @return [Array<Oga::XML::Attribute>]
    #
    class Element < Node
      attr_accessor :name, :namespace, :attributes

      ##
      # @param [Hash] options
      #
      # @option options [String] :name The name of the element.
      # @option options [String] :namespace The namespace of the element.
      # @option options [Array<Oga::XML::Attribute>] :attributes The attributes
      #  of the element as an Array.
      #
      def initialize(options = {})
        super

        @name       = options[:name]
        @namespace  = options[:namespace]
        @attributes = options[:attributes] || []
      end

      ##
      # Returns the attribute of the given name.
      #
      # @example
      #  # find an attribute that only has the name "foo"
      #  attribute('foo')
      #
      #  # find an attribute with namespace "foo" and name bar"
      #  attribute('foo:bar')
      #
      # @param [String] name
      # @return [String]
      #
      def attribute(name)
        name, ns = split_name(name)

        attributes.each do |attr|
          return attr if attribute_matches?(attr, ns, name)
        end

        return
      end

      alias_method :attr, :attribute

      ##
      # Returns the text of all child nodes joined together.
      #
      # @return [String]
      #
      def text
        return children.text
      end

      ##
      # Returns the text of the current element only.
      #
      # @return [String]
      #
      def inner_text
        text = ''

        children.each do |child|
          text << child.text if child.is_a?(Text)
        end

        return text
      end

      ##
      # Converts the element and its child elements to XML.
      #
      # @return [String]
      #
      def to_xml
        ns    = namespace ? "#{namespace}:" : ''
        body  = children.map(&:to_xml).join('')
        attrs = ''

        attributes.each do |key, value|
          attrs << "#{key}=#{value.inspect}"
        end

        attrs = " #{attrs}" unless attrs.empty?

        return "<#{ns}#{name}#{attrs}>#{body}</#{name}>"
      end

      ##
      # Returns extra data to use when calling {#inspect} on an element.
      #
      # @param [Fixnum] indent
      # @return [String]
      #
      def extra_inspect_data(indent)
        spacing     = ' ' * indent
        child_lines = children.map { |child| child.inspect(indent + 4) }
          .join("\n")

        segments = []

        [:name, :namespace, :attributes].each do |attr|
          value = send(attr)

          if value and !value.empty?
            segments << "#{attr}: #{value.inspect}"
          end
        end

        return <<-EOF.chomp

#{spacing}  #{segments.join("\n#{spacing}  ")}
#{spacing}  children: [
#{child_lines}
#{spacing}]
        EOF
      end

      ##
      # @return [Symbol]
      #
      def node_type
        return :element
      end

      private

      ##
      # @param [String] name
      # @return [Array]
      #
      def split_name(name)
        segments = name.to_s.split(':')

        return segments.pop, segments.pop
      end

      ##
      # @param [Oga::XML::Attribute] attr
      # @param [String] ns
      # @param [String] name
      # @return [TrueClass|FalseClass]
      #
      def attribute_matches?(attr, ns, name)
        name_matches = attr.name == name
        ns_matches   = false

        if ns
          ns_matches = attr.namespace == ns

        elsif name_matches
          ns_matches = true
        end

        return name_matches && ns_matches
      end
    end # Element
  end # XML
end # Oga
