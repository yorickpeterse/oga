module Oga
  module XML
    ##
    # Class for building a DOM tree of XML/HTML nodes.
    #
    # @!attribute [r] ast
    #  @return [Oga::AST::Node]
    #
    class TreeBuilder < ::AST::Processor
      attr_reader :ast

      def on_document(node)
        document = Document.new
        document.children = process_all(node)

        document.children.each do |child|
          child.parent = document
        end

        return document
      end

      def on_comment(node)
        return Comment.new(:text => node.children[0])
      end

      def on_element(node)
        ns, name, attr, *children = *node

        if attr
          attr = process(attr)
        end

        if children
          children = process_all(children)
        end

        element = Element.new(
          :name       => name,
          :namespace  => ns,
          :attributes => attr,
          :children   => children
        )

        element.children.each_with_index do |child, index|
          if index > 0
            child.previous = element.children[index - 1]
          end

          if index + 1 <= element.children.length
            child.next = element.children[index + 1]
          end

          child.parent = element
        end

        return element
      end

      def on_text(node)
        return Text.new(:text => node.children[0])
      end

      def on_cdata(node)
        return Cdata.new(:text => node.children[0])
      end

      def on_attributes(node)
        pairs = process_all(node)

        return Hash[pairs]
      end

      def on_attribute(node)
        return *node
      end
    end # TreeBuilder
  end # XML
end # Oga
