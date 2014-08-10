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
    class Document
      attr_accessor :doctype, :xml_declaration

      ##
      # @param [Hash] options
      #
      # @option options [Oga::XML::NodeSet] :children
      # @option options [Oga::XML::Doctype] :doctype
      # @option options [Oga::XML::XmlDeclaration] :xml_declaration
      #
      def initialize(options = {})
        @doctype         = options[:doctype]
        @xml_declaration = options[:xml_declaration]

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
      # Traverses through the document and yields every node to the supplied
      # block.
      #
      # The block's body can also determine whether or not to traverse child
      # nodes. Preventing a node's children from being traversed can be done by
      # using `throw :skip_children`
      #
      # This method uses a combination of breadth-first and depth-first
      # traversal to traverse the entire XML tree in document order. See
      # http://en.wikipedia.org/wiki/Breadth-first_search for more information.
      #
      # @example
      #  document.each_node do |node|
      #    p node.class
      #  end
      #
      # @example Skipping the children of a certain node
      #  document.each_node do |node|
      #    if node.is_a?(Oga::XML::Element) and node.name == 'book'
      #      throw :skip_children
      #    end
      #  end
      #
      # @yieldparam [Oga::XML::Node] The current node.
      #
      def each_node
        visit = children.to_a.dup # copy it since we're modifying the array

        until visit.empty?
          current = visit.shift

          catch :skip_children do
            yield current

            visit = current.children.to_a + visit
          end
        end
      end

      ##
      # Returns the available namespaces. These namespaces are retrieved from
      # the first element in the document.
      #
      # @see [Oga::XML::Element#available_namespaces]
      #
      def available_namespaces
        children.each do |child|
          # There's no guarantee that the first node is *always* an element
          # node.
          return child.available_namespaces if child.is_a?(Element)
        end

        # In case the document is empty.
        return {}
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
