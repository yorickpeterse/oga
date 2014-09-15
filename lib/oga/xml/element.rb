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
    # @!attribute [ww] namespace_name
    #  The name of the namespace.
    #  @return [String]
    #
    # @!attribute [rw] attributes
    #  The attributes of the element.
    #  @return [Array<Oga::XML::Attribute>]
    #
    # @!attribute [rw] namespaces
    #  The registered namespaces.
    #  @return [Hash]
    #
    class Element < Node
      include Querying

      attr_accessor :name, :namespace_name, :attributes, :namespaces

      ##
      # The attribute prefix/namespace used for registering element namespaces.
      #
      # @return [String]
      #
      XMLNS_PREFIX = 'xmlns'.freeze

      ##
      # @param [Hash] options
      #
      # @option options [String] :name The name of the element.
      #
      # @option options [String] :namespace_name The name of the namespace.
      #
      # @option options [Array<Oga::XML::Attribute>] :attributes The attributes
      #  of the element as an Array.
      #
      def initialize(options = {})
        super

        @name           = options[:name]
        @namespace_name = options[:namespace_name]
        @attributes     = options[:attributes] || []
        @namespaces     = options[:namespaces] || {}

        link_attributes
        register_namespaces_from_attributes
      end

      ##
      # Returns an attribute matching the given name (with or without the
      # namespace).
      #
      # @example
      #  # find an attribute that only has the name "foo"
      #  attribute('foo')
      #
      #  # find an attribute with namespace "foo" and name bar"
      #  attribute('foo:bar')
      #
      # @param [String|Symbol] name The name (with or without the namespace)
      #  of the attribute.
      #
      # @return [Oga::XML::Attribute]
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
      # Returns the value of the given attribute.
      #
      # @example
      #  element.get('class') # => "container"
      #
      # @see [#attribute]
      #
      def get(name)
        found = attribute(name)

        return found ? found.value : nil
      end

      ##
      # Adds a new attribute to the element.
      #
      # @param [Oga::XML::Attribute] attribute
      #
      def add_attribute(attribute)
        attribute.element = self

        attributes << attribute
      end

      ##
      # Sets the value of an attribute to the given value. If the attribute does
      # not exist it is created automatically.
      #
      # @param [String] name The name of the attribute, optionally including the
      #  namespace.
      #
      # @param [String] value The new value of the attribute.
      #
      def set(name, value)
        found = attribute(name)

        if found
          found.value = value
        else
          if name.include?(':')
            ns, name = name.split(':')
          else
            ns = nil
          end

          attr = Attribute.new(
            :name           => name,
            :namespace_name => ns,
            :value          => value
          )

          add_attribute(attr)
        end
      end

      ##
      # Returns the namespace of the element.
      #
      # @return [Oga::XML::Namespace]
      #
      def namespace
        unless @namespace
          available  = available_namespaces
          @namespace = available[namespace_name] || available[XMLNS_PREFIX]
        end

        return @namespace
      end

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

        text_nodes.each do |node|
          text << node.text
        end

        return text
      end

      ##
      # Returns any {Oga::XML::Text} nodes that are a direct child of this
      # element.
      #
      # @return [Oga::XML::NodeSet]
      #
      def text_nodes
        nodes = NodeSet.new

        children.each do |child|
          nodes << child if child.is_a?(Text)
        end

        return nodes
      end

      ##
      # Sets the inner text of the current element to the given String.
      #
      # @param [String] text
      #
      def inner_text=(text)
        children.each do |child|
          child.remove if child.is_a?(Text)
        end

        children << XML::Text.new(:text => text)
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

        attributes.each do |attr|
          attrs << " #{attr.to_xml}"
        end

        return "<#{ns}#{name}#{attrs}>#{body}</#{ns}#{name}>"
      end

      ##
      # @return [String]
      #
      def inspect
        segments = []

        [:name, :namespace, :attributes, :children].each do |attr|
          value = send(attr)

          if !value or (value.respond_to?(:empty?) and value.empty?)
            next
          end

          segments << "#{attr}: #{value.inspect}"
        end

        return "Element(#{segments.join(' ')})"
      end

      ##
      # Registers a new namespace for the current element and its child
      # elements.
      #
      # @param [String] name
      # @param [String] uri
      # @see [Oga::XML::Namespace#initialize]
      #
      def register_namespace(name, uri)
        if namespaces[name]
          raise ArgumentError, "The namespace #{name.inspect} already exists"
        end

        namespaces[name] = Namespace.new(:name => name, :uri => uri)
      end

      ##
      # Returns a Hash containing all the namespaces available to the current
      # element.
      #
      # @return [Hash]
      #
      def available_namespaces
        merged = namespaces
        node   = parent

        while node && node.respond_to?(:namespaces)
          node.namespaces.each do |prefix, ns|
            merged[prefix] = ns unless merged[prefix]
          end

          node = node.parent
        end

        return merged
      end

      private

      ##
      # Registers namespaces based on any "xmlns" attributes. Once a namespace
      # has been registered the corresponding attribute is removed.
      #
      def register_namespaces_from_attributes
        self.attributes = attributes.reject do |attr|
          # We're using `namespace_name` opposed to `namespace.name` as "xmlns"
          # is not a registered namespace.
          remove = attr.name == XMLNS_PREFIX ||
            attr.namespace_name == XMLNS_PREFIX

          # If the attribute sets the default namespace we'll also overwrite the
          # namespace_name.
          if attr.name == XMLNS_PREFIX
            @namespace_name = XMLNS_PREFIX
          end

          register_namespace(attr.name, attr.value) if remove

          remove
        end
      end

      ##
      # Links all attributes to the current element.
      #
      def link_attributes
        attributes.each do |attr|
          attr.element = self
        end
      end

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
          ns_matches = attr.namespace.to_s == ns

        elsif name_matches and !attr.namespace
          ns_matches = true
        end

        return name_matches && ns_matches
      end
    end # Element
  end # XML
end # Oga
