module Oga
  module XML
    ##
    # Class that contains information about an XML element such as the name,
    # attributes and child nodes.
    #
    class Element < Node
      attr_accessor :name, :namespace, :attributes

      def after_initialize
        @attributes ||= {}
      end

      def attribute(name)
        return attributes[name]
      end

      alias_method :attr, :attribute

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
    end # Element
  end # XML
end # Oga
