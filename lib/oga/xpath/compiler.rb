module Oga
  module XPath
    ##
    # Compiling of XPath ASTs into Ruby code.
    #
    # The Compiler class can be used to turn an XPath AST into Ruby source code
    # that can be executed to match XML nodes in a given input document/element.
    # Compiled source code is cached per expression, removing the need for
    # recompiling the same expression over and over again.
    #
    class Compiler
      # @return [Oga::LRU]
      CACHE = LRU.new

      # Wildcard for node names/namespace prefixes.
      STAR = '*'

      ##
      # Compiles and caches an AST.
      #
      # @see [#compile]
      #
      def self.compile_with_cache(ast)
        CACHE.get_or_set(ast) { new.compile(ast) }
      end

      ##
      # Compiles an XPath AST into a Ruby Proc.
      #
      # @param [AST::Node] ast
      # @return [Proc]
      #
      def compile(ast)
        document = node_literal
        matched  = matched_literal

        if ast.type == :path
          ruby_ast = process(ast, document)
        else
          ruby_ast = process(ast, document) do |node|
            matched.push(node)
          end
        end

        proc_ast = literal('lambda').add_block(document) do
          matched.assign(literal(XML::NodeSet).new)
            .followed_by(ruby_ast)
            .followed_by(matched)
        end

        generator = Ruby::Generator.new
        source    = generator.process(proc_ast)

        eval(source)
      end

      ##
      # Processes a single XPath AST node.
      #
      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
      def process(ast, input, &block)
        send("on_#{ast.type}", ast, input, &block)
      end

      ##
      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
      def on_path(ast, input, &block)
        matched    = matched_literal
        ruby_ast   = nil
        var_name   = node_literal
        last_index = ast.children.length - 1

        ast.children.reverse_each.with_index do |child, index|
          # The first block should operate on the variable set in "input", all
          # others should operate on the child variables ("node").
          input_var = index == last_index ? input : var_name

          # The last segment of the path should add the code that actually
          # pushes the matched node into the node set.
          if index == 0
            ruby_ast = process(child, input_var) do |node|
              matched.push(node)
            end
          else
            ruby_ast = process(child, input_var) { ruby_ast }
          end
        end

        ruby_ast
      end

      ##
      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
      def on_absolute_path(ast, input, &block)
        if ast.children.empty?
          matched_literal.push(input.root_node)
        else
          on_path(ast, input.root_node, &block)
        end
      end

      ##
      # Dispatches the processing of axes to dedicated methods. This works
      # similar to {#process} except the handler names are "on_axis_X" with "X"
      # being the axis name.
      #
      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
      def on_axis(ast, input, &block)
        name, test = *ast.children

        handler = name.gsub('-', '_')

        send(:"on_axis_#{handler}", test, input, &block)
      end

      ##
      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
      def on_axis_child(ast, input, &block)
        child     = node_literal
        condition = process(ast, child, &block)

        input.children.each.add_block(child) do
          condition.if_true { yield child }
        end
      end

      ##
      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
      def on_axis_attribute(ast, input)
        ns, name = *ast

        query = ns ? "#{ns}:#{name}" : name

        input.get(string(query))
      end

      ##
      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
      def on_predicate(ast, input, &block)
        test, predicate = *ast

        process(test, input) do |node|
          process(predicate, node).if_true(&block)
        end
      end

      ##
      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
      def on_test(ast, input)
        ns, name = *ast

        condition = element_or_attribute(input)

        if name != STAR
          condition = condition.and(input.name.eq(string(name)))
        end

        if ns and ns != STAR
          condition = condition.and(input.namespace_name.eq(string(ns)))
        end

        condition
      end

      ##
      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
      def on_eq(ast, input)
        left, right = *ast

        process(left, input).eq(process(right, input))
      end

      ##
      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
      def on_string(ast, input)
        string(ast.children[0])
      end

      ##
      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
      def on_int(ast, input)
        literal(ast.children[0].to_s)
      end

      private

      ##
      # @param [#to_s] value
      # @return [Oga::Ruby::Node]
      #
      def literal(value)
        Ruby::Node.new(:lit, [value.to_s])
      end

      ##
      # @param [#to_s] value
      # @return [Oga::Ruby::Node]
      #
      def string(value)
        Ruby::Node.new(:string, [value.to_s])
      end

      ##
      # @param [Oga::Ruby::Node] node
      # @return [Oga::Ruby::Node]
      #
      def element_or_attribute(node)
        node.is_a?(XML::Attribute).or(node.is_a?(XML::Element))
      end

      # @return [Oga::Ruby::Node]
      def matched_literal
        literal('matched')
      end

      # @return [Oga::Ruby::Node]
      def node_literal
        literal('node')
      end
    end # Compiler
  end # XPath
end # Oga
