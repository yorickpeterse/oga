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
    #  @return [Hash]
    #
    class Element < Node
      attr_accessor :name, :namespace, :attributes

      ##
      # @param [Hash] options
      #
      # @option options [String] :name The name of the element.
      # @option options [String] :namespace The namespace of the element.
      # @option options [Hash] :attributes The attributes of the element.
      #
      def initialize(options = {})
        super

        @name       = options[:name]
        @namespace  = options[:namespace]
        @attributes = options[:attributes] || {}
      end

      ##
      # Returns the value of the specified attribute.
      #
      # @param [String] name
      # @return [String]
      #
      def attribute(name)
        return attributes[name.to_sym]
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

        return <<-EOF.chomp

#{spacing}  name: #{name.inspect}
#{spacing}  namespace: #{namespace.inspect}
#{spacing}  attributes: #{attributes.inspect}
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
    end # Element
  end # XML
end # Oga
