module Oga
  module XML
    ##
    # The TreeBuilder class turns an AST into a DOM tree. This DOM tree can be
    # traversed by requesting child elements, parent elements, etc.
    #
    # Basic usage:
    #
    #     builder = Oga::XML::TreeBuilder.new
    #     ast     = s(:element, ...)
    #
    #     builder.process(ast) # => #<Oga::XML::Document ...>
    #
    class TreeBuilder < ::AST::Processor
      ##
      # @param [Oga::AST::Node] node
      # @return [Oga::XML::Document]
      #
      def on_document(node)
        document = Document.new

        process_all(node).each do |child|
          if child.is_a?(XmlDeclaration)
            document.xml_declaration = child
          else
            document.children << child
          end
        end

        document.children.each do |child|
          child.parent = document
        end

        return document
      end

      ##
      # @param [Oga::AST::Node] node
      # @return [Oga::XML::XmlDeclaration]
      #
      def on_xml_decl(node)
        attributes = process(node.children[0])

        return XmlDeclaration.new(attributes)
      end

      ##
      # @param [Oga::AST::Node] node
      # @return [Oga::XML::Comment]
      #
      def on_comment(node)
        return Comment.new(:text => node.children[0])
      end

      ##
      # Processes an `(element)` node and its child elements.
      #
      # An element can have a parent, previous and next element as well as a
      # number of child elements.
      #
      # @param [Oga::AST::Node] node
      # @return [Oga::XML::Element]
      #
      def on_element(node)
        ns, name, attr, *children = *node

        if attr
          attr = process(attr)
        end

        if children
          children = process_all(children.compact)
        end

        element = Element.new(
          :name       => name,
          :namespace  => ns,
          :attributes => attr,
          :children   => children
        )

        process_children(element)

        return element
      end

      ##
      # @param [Oga::AST::Node] node
      # @return [Oga::XML::Text]
      #
      def on_text(node)
        return Text.new(:text => node.children[0])
      end

      ##
      # @param [Oga::AST::Node] node
      # @return [Oga::XML::Cdata]
      #
      def on_cdata(node)
        return Cdata.new(:text => node.children[0])
      end

      ##
      # Converts a `(attributes)` node into a Hash.
      #
      # @param [Oga::AST::Node] node
      # @return [Hash]
      #
      def on_attributes(node)
        pairs = process_all(node)

        return Hash[pairs]
      end

      ##
      # @param [Oga::AST::Node] node
      # @return [Array]
      #
      def on_attribute(node)
        return *node
      end

      def handler_missing(node)
        raise "No handler for node type #{node.type.inspect}"
      end

      private

      ##
      # Iterates over the child elements of an element and assigns the parent,
      # previous and next elements. The supplied object is modified in place.
      #
      # @param [Oga::XML::Element] element
      #
      def process_children(element)
        amount = element.children.length

        element.children.each_with_index do |child, index|
          prev_index = index - 1
          next_index = index + 1

          if index > 0
            child.previous = element.children[prev_index]
          end

          if next_index <= amount
            child.next = element.children[next_index]
          end

          child.parent = element
        end
      end
    end # TreeBuilder
  end # XML
end # Oga
