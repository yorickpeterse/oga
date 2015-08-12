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
    # @private
    #
    class Compiler
      # @return [Oga::LRU]
      CACHE = LRU.new

      # Wildcard for node names/namespace prefixes.
      STAR = '*'

      # Node types that require a NodeSet to push nodes into.
      RETURN_NODESET = [:path, :absolute_path, :axis, :predicate]

      # Hash containing all operator callbacks, the conversion methods and the
      # Ruby methods to use.
      OPERATORS = {
        :on_add => [:to_float, :+],
        :on_sub => [:to_float, :-],
        :on_div => [:to_float, :/],
        :on_gt  => [:to_float, :>],
        :on_gte => [:to_float, :>=],
        :on_lt  => [:to_float, :<],
        :on_lte => [:to_float, :<=],
        :on_mul => [:to_float, :*],
        :on_mod => [:to_float, :%],
        :on_and => [:to_boolean, :and],
        :on_or  => [:to_boolean, :or]
      }

      ##
      # Compiles and caches an AST.
      #
      # @see [#compile]
      #
      def self.compile_with_cache(ast)
        CACHE.get_or_set(ast) { new.compile(ast) }
      end

      def initialize
        reset
      end

      # Resets the internal state.
      def reset
        @literal_id = 0
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

        if return_nodeset?(ast)
          ruby_ast = process(ast, document) { |node| matched.push(node) }
        else
          ruby_ast = process(ast, document)
        end

        vars = variables_literal.assign(self.nil)

        proc_ast = literal(:lambda).add_block(document, vars) do
          input_assign = original_input_literal.assign(document)

          if return_nodeset?(ast)
            body = matched.assign(literal(XML::NodeSet).new)
              .followed_by(input_assign)
              .followed_by(ruby_ast)
              .followed_by(matched)
          else
            body = ruby_ast
          end

          input_assign.followed_by(body)
        end

        generator = Ruby::Generator.new
        source    = generator.process(proc_ast)

        eval(source)
      ensure
        reset
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

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_path(ast, input, &block)
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
            ruby_ast = process(child, input_var, &block)
          else
            ruby_ast = process(child, input_var) { ruby_ast }
          end
        end

        ruby_ast
      end

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
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
        name, test = *ast

        handler = name.gsub('-', '_')

        send(:"on_axis_#{handler}", test, input, &block)
      end

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_axis_child(ast, input, &block)
        child     = node_literal
        condition = process(ast, child, &block)

        input.children.each.add_block(child) do
          condition.if_true { yield child }
        end
      end

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_axis_attribute(ast, input)
        input.is_a?(XML::Element).if_true do
          attribute = literal(:attribute)

          input.attributes.each.add_block(attribute) do
            name_match = match_name_and_namespace(ast, attribute)

            if name_match
              name_match.if_true { yield attribute }
            else
              yield attribute
            end
          end
        end
      end

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_axis_ancestor_or_self(ast, input, &block)
        parent = node_literal

        process(ast, input, &block)
          .if_true { yield input }
          .followed_by do
            input.each_ancestor.add_block(parent) do
              process(ast, parent, &block).if_true { yield parent }
            end
          end
      end

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_axis_ancestor(ast, input, &block)
        parent = node_literal

        input.each_ancestor.add_block(parent) do
          process(ast, parent, &block).if_true { yield parent }
        end
      end

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_axis_descendant_or_self(ast, input, &block)
        node = node_literal

        backup_variable(node, input) do
          process(ast, node, &block)
            .if_true { yield node }
            .followed_by do
              node.each_node.add_block(node) do
                process(ast, node, &block).if_true { yield node }
              end
            end
        end
      end

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_axis_descendant(ast, input, &block)
        node = node_literal

        backup_variable(node, input) do
          node.each_node.add_block(node) do
            process(ast, node, &block).if_true { yield node }
          end
        end
      end

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_axis_parent(ast, input, &block)
        node = node_literal

        input.is_a?(XML::Node).if_true do
          backup_variable(node, input.parent) do
            process(ast, node, &block).if_true { yield node }
          end
        end
      end

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_axis_self(ast, input, &block)
        node = node_literal

        backup_variable(node, input) do
          process(ast, node, &block).if_true { yield node }
        end
      end

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_axis_following_sibling(ast, input, &block)
        node       = node_literal
        orig_input = original_input_literal
        doc_node   = literal(:doc_node)
        check      = literal(:check)
        parent     = literal(:parent)
        root       = literal(:root)

        orig_input.is_a?(XML::Node)
          .if_true { root.assign(orig_input.parent) }
          .else    { root.assign(orig_input) }
          .followed_by do
            input.is_a?(XML::Node).and(input.parent)
              .if_true { parent.assign(input.parent) }
              .else    { parent.assign(self.nil) }
          end
          .followed_by(check.assign(self.false))
          .followed_by do
            root.each_node.add_block(doc_node) do
              doc_node.eq(input)
                .if_true do
                  check.assign(self.true)
                    .followed_by(throw_message(:skip_children))
                end
                .followed_by do
                  check.not.or(parent != doc_node.parent).if_true do
                    send_message(:next)
                  end
                end
                .followed_by do
                  backup_variable(node, doc_node) do
                    process(ast, node, &block).if_true do
                      yield(node).followed_by(throw_message(:skip_children))
                    end
                  end
                end
            end
          end
      end

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_axis_following(ast, input, &block)
        node       = node_literal
        orig_input = original_input_literal
        doc_node   = literal(:doc_node)
        check      = literal(:check)
        root       = literal(:root)

        orig_input.is_a?(XML::Node)
          .if_true { root.assign(orig_input.root_node) }
          .else    { root.assign(orig_input) }
          .followed_by(check.assign(self.false))
          .followed_by do
            root.each_node.add_block(doc_node) do
              doc_node.eq(input)
                .if_true do
                  check.assign(self.true)
                    .followed_by(throw_message(:skip_children))
                end
                .followed_by do
                  check.not.if_true { send_message(:next) }
                end
                .followed_by do
                  backup_variable(node, doc_node) do
                    process(ast, node, &block).if_true do
                      yield node
                    end
                  end
                end
            end
          end
      end

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_axis_namespace(ast, input)
        underscore = literal(:_)
        node       = node_literal

        name = string(ast.children[1])
        star = string(STAR)

        input.is_a?(XML::Element).if_true do
          input.available_namespaces.each.add_block(underscore, node) do
            node.name.eq(name).or(name.eq(star)).if_true { yield node }
          end
        end
      end

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_axis_preceding(ast, input, &block)
        orig_input = original_input_literal
        root       = literal(:root)
        node       = node_literal
        doc_node   = literal(:doc_node)

        orig_input.is_a?(XML::Node)
          .if_true { root.assign(orig_input.root_node) }
          .else    { root.assign(orig_input) }
          .followed_by do
            root.each_node.add_block(doc_node) do
              doc_node.eq(input)
                .if_true { self.break }
                .followed_by do
                  backup_variable(node, doc_node) do
                    process(ast, node, &block).if_true { yield node }
                  end
                end
            end
          end
      end

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_axis_preceding_sibling(ast, input, &block)
        orig_input = original_input_literal
        check      = literal(:check)
        root       = literal(:root)
        node       = node_literal
        parent     = literal(:parent)
        doc_node   = literal(:doc_node)

        orig_input.is_a?(XML::Node)
          .if_true { root.assign(orig_input.parent) }
          .else    { root.assign(orig_input) }
          .followed_by(check.assign(self.false))
          .followed_by do
            input.is_a?(XML::Node).and(input.parent)
              .if_true { parent.assign(input.parent) }
              .else    { parent.assign(self.nil) }
          end
          .followed_by do
            root.each_node.add_block(doc_node) do
              doc_node.eq(input)
                .if_true { self.break }
                .followed_by do
                  doc_node.parent.eq(parent).if_true do
                    backup_variable(node, doc_node) do
                      process(ast, node, &block).if_true { yield node }
                    end
                  end
                end
            end
          end
      end

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_predicate(ast, input, &block)
        test, predicate = *ast

        if number?(predicate)
          on_index_predicate(test, predicate, input, &block)
        else
          on_expression_predicate(test, predicate, input, &block)
        end
      end

      ##
      # Processes an index predicate such as `foo[10]`.
      #
      # @param [AST::Node] test
      # @param [AST::Node] predicate
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
      def on_index_predicate(test, predicate, input)
        int1      = literal('1')
        index     = to_int(predicate)
        index_var = literal(:index)

        index_var.assign(int1)
          .followed_by do
            process(test, input) do |matched_test_node|
              index_var.eq(index)
                .if_true { yield matched_test_node }
                .followed_by(index_var.assign(index_var + int1))
            end
          end
      end

      ##
      # Processes a predicate using an expression (e.g. a path).
      #
      # @param [AST::Node] test
      # @param [AST::Node] predicate
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
      def on_expression_predicate(test, predicate, input)
        process(test, input) do |matched_test_node|
          catch_message(:predicate_matched) do
            process(predicate, matched_test_node) do
              throw_message(:predicate_matched, self.true)
            end
          end
          .if_true { yield matched_test_node }
        end
      end

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_test(ast, input)
        condition  = element_or_attribute(input)
        name_match = match_name_and_namespace(ast, input)

        name_match ? condition.and(name_match) : condition
      end

      ##
      # Processes the `=` operator.
      #
      # @see [#operator]
      #
      def on_eq(ast, input, &block)
        conv = literal(Conversion)

        operator(ast, input) do |left, right|
          mass_assign([left, right], conv.to_compatible_types(left, right))
            .followed_by do
              operation = left.eq(right)

              block ? operation.if_true(&block) : operation
            end
        end
      end

      ##
      # Processes the `!=` operator.
      #
      # @see [#operator]
      #
      def on_neq(ast, input, &block)
        conv = literal(Conversion)

        operator(ast, input) do |left, right|
          mass_assign([left, right], conv.to_compatible_types(left, right))
            .followed_by do
              operation = left != right

              block ? operation.if_true(&block) : operation
            end
        end
      end

      OPERATORS.each do |callback, (conv_method, ruby_method)|
        define_method(callback) do |ast, input, &block|
          conversion = literal(XPath::Conversion)

          operator(ast, input) do |left, right|
            lval      = conversion.__send__(conv_method, left)
            rval      = conversion.__send__(conv_method, right)
            operation = lval.__send__(ruby_method, rval)

            block ? conversion.to_boolean(operation).if_true(&block) : operation
          end
        end
      end

      ##
      # Processes the `|` operator.
      #
      # @see [#operator]
      #
      def on_pipe(ast, input, &block)
        left, right = *ast

        union      = unique_literal(:union)
        conversion = literal(Conversion)

        union.assign(literal(XML::NodeSet).new)
          .followed_by(process(left, input) { |node| union << node })
          .followed_by(process(right, input) { |node| union << node })
          .followed_by do
            # block present means we're in a predicate
            block ? conversion.to_boolean(union).if_true(&block) : union
          end
      end

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_string(ast, *)
        string(ast.children[0])
      end

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_int(ast, *)
        literal(ast.children[0].to_f.to_s)
      end

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_float(ast, *)
        literal(ast.children[0].to_s)
      end

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_var(ast, input)
        vars = variables_literal
        name = ast.children[0]

        variables_literal.and(variables_literal[string(name)])
          .or(send_message(:raise, string("Undefined XPath variable: #{name}")))
      end

      ##
      # Delegates function calls to specific handlers.
      #
      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
      def on_call(ast, input, &block)
        name, *args = *ast

        handler = name.gsub('-', '_')

        send(:"on_call_#{handler}", input, *args, &block)
      end

      # @return [Oga::Ruby::Node]
      def on_call_true(*)
        self.true
      end

      # @return [Oga::Ruby::Node]
      def on_call_false(*)
        self.false
      end

      # @param [Oga::Ruby::Node] input
      # @param [AST::Node] arg
      # @return [Oga::Ruby::Node]
      def on_call_boolean(input, arg)
        arg_ast    = try_match_first_node(arg, input)
        call_arg   = unique_literal(:call_arg)
        conversion = literal(Conversion)

        call_arg.assign(arg_ast)
          .followed_by(conversion.to_boolean(call_arg))
      end

      # @param [Oga::Ruby::Node] input
      # @param [AST::Node] arg
      # @return [Oga::Ruby::Node]
      def on_call_ceiling(input, arg)
        arg_ast    = try_match_first_node(arg, input)
        call_arg   = unique_literal(:call_arg)
        conversion = literal(Conversion)

        call_arg.assign(arg_ast)
          .followed_by do
            call_arg.assign(conversion.to_float(call_arg))
          end
          .followed_by do
            call_arg.nan?.if_true { call_arg }.else { call_arg.ceil.to_f }
          end
      end

      # @param [Oga::Ruby::Node] input
      # @param [AST::Node] arg
      # @return [Oga::Ruby::Node]
      def on_call_floor(input, arg)
        arg_ast    = try_match_first_node(arg, input)
        call_arg   = unique_literal(:call_arg)
        conversion = literal(Conversion)

        call_arg.assign(arg_ast)
          .followed_by do
            call_arg.assign(conversion.to_float(call_arg))
          end
          .followed_by do
            call_arg.nan?.if_true { call_arg }.else { call_arg.floor.to_f }
          end
      end

      # @param [Oga::Ruby::Node] input
      # @param [AST::Node] arg
      # @return [Oga::Ruby::Node]
      def on_call_round(input, arg)
        arg_ast    = try_match_first_node(arg, input)
        call_arg   = unique_literal(:call_arg)
        conversion = literal(Conversion)

        call_arg.assign(arg_ast)
          .followed_by do
            call_arg.assign(conversion.to_float(call_arg))
          end
          .followed_by do
            call_arg.nan?.if_true { call_arg }.else { call_arg.round.to_f }
          end
      end

      # @param [Oga::Ruby::Node] input
      # @param [Array<AST::Node>] args
      # @return [Oga::Ruby::Node]
      def on_call_concat(input, *args)
        conversion  = literal(Conversion)
        assigns     = []
        conversions = []

        args.each do |arg|
          arg_var = unique_literal(:concat_arg)
          arg_ast = try_match_first_node(arg, input)

          assigns     << arg_var.assign(arg_ast)
          conversions << conversion.to_string(arg_var)
        end

        assigns.inject(:followed_by)
          .followed_by(conversions.inject(:+))
      end

      # @param [Oga::Ruby::Node] input
      # @param [AST::Node] haystack_ast
      # @param [AST::Node] needle_ast
      # @return [Oga::Ruby::Node]
      def on_call_contains(input, haystack, needle)
        haystack_lit = unique_literal(:haystack)
        needle_lit   = unique_literal(:needle)
        conversion   = literal(Conversion)

        haystack_lit.assign(try_match_first_node(haystack, input))
          .followed_by do
            needle_lit.assign(try_match_first_node(needle, input))
          end
          .followed_by do
            conversion.to_string(haystack_lit)
              .include?(conversion.to_string(needle_lit))
          end
      end

      # @param [Oga::Ruby::Node] input
      # @param [AST::Node] arg
      # @return [Oga::Ruby::Node]
      def on_call_count(input, arg)
        count  = unique_literal(:count)
        assign =

        unless return_nodeset?(arg)
          raise TypeError, 'count() can only operate on NodeSet instances'
        end

        count.assign(literal('0.0'))
          .followed_by do
            process(arg, input) { count.assign(count + literal('1')) }
          end
          .followed_by(count)
      end

      ##
      # Processes the `id()` function call.
      #
      # The XPath specification states that this function's behaviour should be
      # controlled by a DTD. If a DTD were to specify that the ID attribute for
      # a certain element would be "foo" then this function should use said
      # attribute.
      #
      # Oga does not support DTD parsing/evaluation and as such always uses the
      # "id" attribute.
      #
      # This function searches the entire document for a matching node,
      # regardless of the current position.
      #
      # @param [Oga::Ruby::Node] input
      # @param [AST::Node] arg
      # @return [Oga::Ruby::Node]
      #
      def on_call_id(input, arg)
        orig_input = original_input_literal
        node       = node_literal
        ids_var    = unique_literal('ids')
        matched    = unique_literal('id_matched')
        id_str_var = unique_literal('id_string')
        attr_var   = unique_literal('attr')

        matched.assign(literal(XML::NodeSet).new)
          .followed_by do
            # When using some sort of path we'll want the text of all matched
            # nodes.
            if return_nodeset?(arg)
              ids_var.assign(literal(:[])).followed_by do
                process(arg, input) { |node| ids_var << node.text }
              end

            # For everything else we'll cast the value to a string and split it
            # on every space.
            else
              conversion = literal(Conversion).to_string(ids_var)
                .split(string(' '))

              ids_var.assign(process(arg, input))
                .followed_by(ids_var.assign(conversion))
            end
          end
          .followed_by do
            id_str_var.assign(string('id'))
          end
          .followed_by do
            orig_input.each_node.add_block(node) do
              node.is_a?(XML::Element).if_true do
                attr_var.assign(node.attribute(id_str_var)).followed_by do
                  attr_var.and(ids_var.include?(attr_var.value))
                    .if_true { matched << node }
                end
              end
            end
          end
          .followed_by(matched)
      end

      # @param [Oga::Ruby::Node] input
      # @param [AST::Node] arg
      # @return [Oga::Ruby::Node]
      def on_call_lang(input, arg)
        lang_var = unique_literal('lang')
        node     = unique_literal('node')
        found    = unique_literal('found')
        xml_lang = unique_literal('xml_lang')
        matched  = unique_literal('matched')

        conversion = literal(Conversion)

        ast = lang_var.assign(try_match_first_node(arg, input))
          .followed_by do
            lang_var.assign(conversion.to_string(lang_var))
          end
          .followed_by do
            matched.assign(self.false)
          end
          .followed_by do
            node.assign(input)
          end
          .followed_by do
            xml_lang.assign(string('xml:lang'))
          end
          .followed_by do
            node.respond_to?(symbol(:attribute)).while_true do
              found.assign(node.get(xml_lang))
                .followed_by do
                  found.if_true do
                    found.eq(lang_var)
                      .if_true do
                        if block_given?
                          yield
                        else
                          matched.assign(self.true).followed_by(self.break)
                        end
                      end
                      .else { self.break }
                  end
                end
                .followed_by(node.assign(node.parent))
            end
          end

        block_given? ? ast : ast.followed_by(matched)
      end

      ##
      # Delegates type tests to specific handlers.
      #
      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
      def on_type_test(ast, input, &block)
        name = ast.children[0]

        handler = name.gsub('-', '_')

        send(:"on_type_test_#{handler}", input, &block)
      end

      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_type_test_comment(input)
        input.is_a?(XML::Comment)
      end

      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_type_test_text(input)
        input.is_a?(XML::Text)
      end

      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_type_test_processing_instruction(input)
        input.is_a?(XML::ProcessingInstruction)
      end

      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def on_type_test_node(input)
        input.is_a?(XML::Node).or(input.is_a?(XML::Document))
      end

      # @param [#to_s] value
      # @return [Oga::Ruby::Node]
      def literal(value)
        Ruby::Node.new(:lit, [value.to_s])
      end

      # @param [String] name
      # @return [Oga::Ruby::Node]
      def unique_literal(name)
        new_id = @literal_id += 1

        literal("#{name}#{new_id}")
      end

      # @param [#to_s] value
      # @return [Oga::Ruby::Node]
      def string(value)
        Ruby::Node.new(:string, [value.to_s])
      end

      # @param [String] value
      # @return [Oga::Ruby::Node]
      def symbol(value)
        Ruby::Node.new(:symbol, [value.to_sym])
      end

      # @param [String] name
      # @param [Array] args
      # @return [Oga::Ruby::Node]
      def send_message(name, *args)
        Ruby::Node.new(:send, [nil, name.to_s, *args])
      end

      # @return [Oga::Ruby::Node]
      def nil
        @nil ||= literal(:nil)
      end

      # @return [Oga::Ruby::Node]
      def true
        @true ||= literal(:true)
      end

      # @return [Oga::Ruby::Node]
      def false
        @false ||= literal(:false)
      end

      # @param [Oga::Ruby::Node] node
      # @return [Oga::Ruby::Node]
      def element_or_attribute(node)
        node.is_a?(XML::Attribute).or(node.is_a?(XML::Element))
      end

      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      def match_name_and_namespace(ast, input)
        ns, name = *ast

        condition = nil

        if name != STAR
          condition = input.name.eq(string(name))
        end

        if ns and ns != STAR
          ns_match  = input.namespace_name.eq(string(ns))
          condition = condition ? condition.and(ns_match) : ns_match
        end

        condition
      end

      ##
      # Returns an AST matching the first node of a node set.
      #
      # @param [Oga::Ruby::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
      def match_first_node(ast, input)
        catch_message(:value) do
          process(ast, input) do |node|
            throw_message(:value, node)
          end
        end
      end

      ##
      # Tries to match the first node in a set, otherwise processes it as usual.
      #
      # @see [#match_first_node]
      #
      def try_match_first_node(ast, input, optimize_first = true)
        if return_nodeset?(ast) and optimize_first
          match_first_node(ast, input)
        else
          process(ast, input)
        end
      end

      ##
      # Generates the code for an operator.
      #
      # The generated code is optimized so that expressions such as `a/b = c`
      # only match the first node in both arms instead of matching all available
      # nodes first. Because numeric operators only ever operates on the first
      # node in a set we can simply ditch the rest, possibly speeding things up
      # quite a bit. This only works if one of the arms is:
      #
      # * a path
      # * an axis
      # * a predicate
      #
      # Everything else is processed the usual (and possibly slower) way.
      #
      # The variables used by this operator are assigned a "begin" block
      # containing the actual result. This ensures that each variable is
      # assigned the result of the entire block instead of the first expression
      # that occurs.
      #
      # For example, take the following expression:
      #
      #     10 = 10 = 20
      #
      # Without a "begin" we'd end up with the following code (trimmed for
      # readability):
      #
      #     eq_left3 = eq_left1 = ...
      #
      #     eq_left2 = ...
      #
      #     eq_left1, eq_left2 = to_compatible_types(eq_left1, eq_left2)
      #
      #     eq_left1 == eq_left2
      #
      #     eq_left4 = ...
      #
      #     eq_left3 == eq_left4
      #
      # This would be incorrect as the first boolean expression (`10 = 10`)
      # would be ignored. By using a "begin" we instead get the following:
      #
      #     eq_left3 = begin
      #       eq_left1 = ...
      #
      #       eq_left2 = ...
      #
      #       eq_left1, eq_left2 = to_compatible_types(eq_left1, eq_left2)
      #
      #       eq_left1 == eq_left2
      #     end
      #
      #     eq_left4 = begin
      #       ...
      #     end
      #
      #     eq_left3 == eq_left4
      #
      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @param [TrueClass|FalseClass] optimize_first
      # @return [Oga::Ruby::Node]
      #
      def operator(ast, input, optimize_first = true)
        left, right = *ast

        left_var  = unique_literal(:op_left)
        right_var = unique_literal(:op_right)

        left_ast  = try_match_first_node(left, input, optimize_first)
        right_ast = try_match_first_node(right, input, optimize_first)

        initial_assign = left_var.assign(left_ast.wrap)
          .followed_by(right_var.assign(right_ast.wrap))
          .followed_by { yield left_var, right_var }
      end

      ##
      # Backs up a local variable and restores it after yielding the block.
      #
      # This is useful when processing axes followed by other segments in a
      # path. In these cases each segment doesn't know about its input (since
      # it's determined later), thus they resort to just using whatever `node`
      # is set to. By re-assigning (and re-storing) this variable the input can
      # be controller more easily.
      #
      # @param [Oga::Ruby::Node] variable
      # @param [Oga::Ruby::Node] new
      # @return [Oga::Ruby::Node]
      #
      def backup_variable(variable, new)
        backup = unique_literal(:backup)

        backup.assign(variable)
          .followed_by(variable.assign(new))
          .followed_by(yield)
          .followed_by(variable.assign(backup))
      end

      # @return [Oga::Ruby::Node]
      def matched_literal
        literal(:matched)
      end

      # @return [Oga::Ruby::Node]
      def node_literal
        literal(:node)
      end

      # @return [Oga::Ruby::Node]
      def original_input_literal
        literal(:original_input)
      end

      # @return [Oga::Ruby::Node]
      def variables_literal
        literal(:variables)
      end

      # @param [AST::Node] ast
      # @return [Oga::Ruby::Node]
      def to_int(ast)
        literal(ast.children[0].to_i.to_s)
      end

      # @param [Array] vars The variables to assign.
      # @param [Oga::Ruby::Node] value
      # @return [Oga::Ruby::Node]
      def mass_assign(vars, value)
        Ruby::Node.new(:massign, [vars, value])
      end

      # @param [AST::Node] ast
      # @return [TrueClass|FalseClass]
      def number?(ast)
        ast.type == :int || ast.type == :float
      end

      # @param [AST::Node] ast
      # @return [TrueClass|FalseClass]
      def string?(ast)
        ast.type == :string
      end

      # @param [Symbol] name
      # @return [Oga::Ruby::Node]
      def catch_message(name)
        send_message(:catch, symbol(name)).add_block do
          # Ensure that the "catch" only returns a value when "throw" is
          # actually invoked.
          yield.followed_by(self.nil)
        end
      end

      # @param [Symbol] name
      # @param [Array] args
      # @return [Oga::Ruby::Node]
      def throw_message(name, *args)
        send_message(:throw, symbol(name), *args)
      end

      # @return [Oga::Ruby::Node]
      def break
        send_message(:break)
      end

      # @param [AST::Node] ast
      # @return [TrueClass|FalseClass]
      def return_nodeset?(ast)
        RETURN_NODESET.include?(ast.type)
      end
    end # Compiler
  end # XPath
end # Oga
