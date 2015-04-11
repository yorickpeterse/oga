module Oga
  module XML
    ##
    # Class used for storing information about an entire XML document. This
    # includes the doctype, XML declaration, child nodes and more.
    #
    # @!attribute [rw] doctype
    #  The doctype of the document.
    #  @return [Oga::XML::Doctype]
    #
    # @!attribute [rw] xml_declaration
    #  The XML declaration of the document.
    #  @return [Oga::XML::XmlDeclaration]
    #
    # @!attribute [r] type
    #  The document type, either `:xml` or `:html`.
    #  @return [Symbol]
    #
    class Document
      include Querying
      include Traversal

      attr_accessor :doctype, :xml_declaration

      attr_reader :type

      ##
      # @param [Hash] options
      #
      # @option options [Oga::XML::NodeSet] :children
      # @option options [Oga::XML::Doctype] :doctype
      # @option options [Oga::XML::XmlDeclaration] :xml_declaration
      # @option options [Symbol] :type
      #
      def initialize(options = {})
        @doctype         = options[:doctype]
        @xml_declaration = options[:xml_declaration]
        @type            = options[:type] || :xml

        self.children = options[:children] if options[:children]
      end

      ##
      # @return [Oga::XML::NodeSet]
      #
      def children
        return @children ||= NodeSet.new([], self)
      end

      ##
      # Sets the child nodes of the document.
      #
      # @param [Oga::XML::NodeSet|Array] nodes
      #
      def children=(nodes)
        if nodes.is_a?(NodeSet)
          @children = nodes
        else
          @children = NodeSet.new(nodes, self)
        end
      end

      ##
      # Converts the document and its child nodes to XML.
      #
      # @return [String]
      #
      def to_xml
        xml = children.map(&:to_xml).join('')

        if doctype
          xml = doctype.to_xml + "\n" + xml.strip
        end

        if xml_declaration
          xml = xml_declaration.to_xml + "\n" + xml.strip
        end

        return xml
      end

      ##
      # @return [TrueClass|FalseClass]
      #
      def html?
        return type == :html
      end

      ##
      # Inspects the document and its child nodes. Child nodes are indented for
      # each nesting level.
      #
      # @return [String]
      #
      def inspect
        segments = []

        [:doctype, :xml_declaration, :children].each do |attr|
          value = send(attr)

          if value
            segments << "#{attr}: #{value.inspect}"
          end
        end

        return <<-EOF.strip
Document(
  #{segments.join("\n  ")}
)
        EOF
      end
    end # Document
  end # XML
end # Oga
