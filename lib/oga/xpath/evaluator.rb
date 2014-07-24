module Oga
  module XPath
    ##
    # The Evaluator class is used to evaluate an XPath expression in the
    # context of a given document.
    #
    class Evaluator
      ##
      # @param [Oga::XML::Document|Oga::XML::Node] document
      #
      def initialize(document)
        @document = document
      end

      ##
      # Evaluates an XPath expression as a String.
      #
      # @example
      #  evaluator = Oga::XPath::Evaluator.new(document)
      #
      #  evaluator.evaluate('//a')
      #
      # @param [String] string An XPath expression as a String.
      # @return [Oga::XML::Node]
      #
      def evaluate(string)
        ast = Parser.new(string).parse

        if @document.is_a?(XML::Document)
          context = @document.children
        else
          context = XML::NodeSet.new([@document])
        end

        return process(ast, context)
      end

      ##
      # Processes an XPath node by dispatching it and the given context to a
      # dedicated handler method. Handler methods are called "on_X" where "X" is
      # the node type.
      #
      # @param [Oga::XPath::Node] node The XPath AST node to process.
      # @param [Oga::XML::NodeSet] context The context (a set of nodes) to
      #  evaluate an expression in.
      #
      # @return [Oga::XML::NodeSet]
      #
      def process(node, context)
        handler = "on_#{node.type}"

        return send(handler, node, context)
      end

      ##
      # Processes an absolute XPath expression such as `/foo`.
      #
      # @param [Oga::XPath::Node] node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_absolute_path(node, context)
        if @document.respond_to?(:root_node)
          context = XML::NodeSet.new([@document.root_node])
        end

        return on_path(node, context)
      end

      ##
      # Processes a relative XPath expression such as `foo`.
      #
      # Paths are evaluated using a "short-circuit" mechanism similar to Ruby's
      # `&&` / `and` operator. Whenever a path results in an empty node set the
      # evaluation is aborted immediately.
      #
      # @param [Oga::XPath::Node] node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_path(node, context)
        last_node = node.children[-1]
        nodes     = XML::NodeSet.new

        node.children.each do |test|
          nodes = process(test, context)

          if test != last_node and !nodes.empty?
            context = child_nodes(context)
          elsif nodes.empty?
            break
          end
        end

        return nodes
      end

      ##
      # Processes a node test. Nodes are compared using {#node_matches?} so see
      # that method for more information on that matching logic.
      #
      # @param [Oga::XPath::Node] node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_test(node, context)
        nodes = XML::NodeSet.new

        context.each do |xml_node|
          if can_match_node?(xml_node) and node_matches?(xml_node, node)
            nodes << xml_node
          end
        end

        return nodes
      end

      ##
      # Dispatches the processing of axes to dedicated methods. This works
      # similar to {#process} except the handler names are "on_axis_X" with "X"
      # being the axis name.
      #
      # @param [Oga::XPath::Node] node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_axis(node, context)
        name, test = *node

        handler = name.gsub('-', '_')

        return send("on_axis_#{handler}", test, context)
      end

      ##
      # Processes the `ancestor` axis. This axis walks through the entire
      # ancestor chain until a matching node is found.
      #
      # Evaluation happens using a "short-circuit" mechanism. The moment a
      # matching node is found it is returned immediately.
      #
      # @param [Oga::XPath::Node] node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_axis_ancestor(node, context)
        nodes = XML::NodeSet.new

        context.each do |xml_node|
          while has_parent?(xml_node)
            xml_node = xml_node.parent

            if can_match_node?(xml_node) and node_matches?(xml_node, node)
              nodes << xml_node
              break
            end
          end
        end

        return nodes
      end

      ##
      # Processes the `ancestor-or-self` axis.
      #
      # @see [#on_axis_ancestor]
      #
      def on_axis_ancestor_or_self(node, context)
        nodes = XML::NodeSet.new

        context.each do |xml_node|
          while has_parent?(xml_node)
            if node_matches?(xml_node, node)
              nodes << xml_node
              break
            end

            xml_node = xml_node.parent
          end
        end

        return nodes
      end

      ##
      # Processes the `attribute` axis. The node test is performed against all
      # the attributes of the nodes in the current context.
      #
      # Evaluation of the nodes continues until the node set has been exhausted
      # (unlike some other methods which return the moment they find a matching
      # node).
      #
      # @param [Oga::XPath::Node] node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_axis_attribute(node, context)
        nodes = XML::NodeSet.new

        context.each do |xml_node|
          next unless xml_node.is_a?(XML::Element)

          nodes += on_test(node, xml_node.attributes)
        end

        return nodes
      end

      ##
      # Evaluates the `child` axis. This simply delegates work to {#on_test}.
      #
      # @param [Oga::XPath::Node] node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_axis_child(node, context)
        return on_test(node, context)
      end

      ##
      # Evaluator the `descendant` axis. This method processes child nodes until
      # the very end of the tree, no "short-circuiting" mechanism is used.
      #
      # @param [Oga::XPath::Node] node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_axis_descendant(node, context)
        nodes    = on_test(node, context)
        children = child_nodes(context)

        unless children.empty?
          nodes += on_axis_descendant(node, children)
        end

        return nodes
      end

      ##
      # Returns a node set containing all the child nodes of the given set of
      # nodes.
      #
      # @param [Oga::XML::NodeSet] nodes
      # @return [Oga::XML::NodeSet]
      #
      def child_nodes(nodes)
        children = XML::NodeSet.new

        nodes.each do |xml_node|
          xml_node.children.each do |child|
            children << child
          end
        end

        return children
      end

      ##
      # Checks if a given {Oga::XML::Node} instance matches a {Oga::XPath::Node}
      # instance.
      #
      # Checking if a node matches happens in two steps:
      #
      # 1. Match the name
      # 2. Match the namespace
      #
      # In both cases a star (`*`) can be used as a wildcard.
      #
      # @param [Oga::XML::Node] xml_node
      # @param [Oga::XPath::Node] ast_node
      # @return [Oga::XML::NodeSet]
      #
      def node_matches?(xml_node, ast_node)
        ns, name = *ast_node

        name_matches = xml_node.name == name || name == '*'
        ns_matches   = false

        if ns
          ns_matches = xml_node.namespace == ns || ns == '*'

        # If there's no namespace given but the name matches we'll also mark
        # the namespace as matching.
        #
        # THINK: stop automatically matching namespaces if left out?
        #
        elsif name_matches
          ns_matches = true
        end

        return name_matches && ns_matches
      end

      ##
      # Returns `true` if the given XML node can be compared using
      # {#node_matches?}.
      #
      # @param [Oga::XML::Node] node
      #
      def can_match_node?(node)
        return node.respond_to?(:name) && node.respond_to?(:namespace)
      end

      ##
      # @param [Oga::XML::Node] node
      # @return [TrueClass|FalseClass]
      #
      def has_parent?(node)
        return node.respond_to?(:parent) && !!node.parent
      end
    end # Evaluator
  end # XPath
end # Oga
