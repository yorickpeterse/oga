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
          if return_nodeset?(ast)
            input_assign = original_input_literal.assign(document)

            matched.assign(literal(XML::NodeSet).new)
              .followed_by(input_assign)
              .followed_by(ruby_ast)
              .followed_by(matched)
          else
            ruby_ast
          end
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

      ##
      # Processes a relative path.
      #
      # @param [AST::Node] ast
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
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
        parent    = node_literal
        self_test = process(ast, input, &block).if_true { yield input }

        ancestors_test = input.each_ancestor.add_block(parent) do
          process(ast, parent, &block).if_true { yield parent }
        end

        self_test.followed_by(ancestors_test)
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
          self_test = process(ast, node, &block).if_true { yield node }

          descendants_test = node.each_node.add_block(node) do
            process(ast, node, &block).if_true { yield node }
          end

          self_test.followed_by(descendants_test)
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

        root_assign = orig_input.is_a?(XML::Node)
          .if_true { root.assign(orig_input.parent) }
          .else    { root.assign(orig_input) }

        parent_if = input.is_a?(XML::Node).and(input.parent)
          .if_true { parent.assign(input.parent) }
          .else    { parent.assign(self.nil) }

        check_assign = check.assign(self.false)

        each_node = root.each_node.add_block(doc_node) do
          doc_compare = doc_node.eq(input).if_true do
            check.assign(self.true)
              .followed_by(throw_message(:skip_children))
          end

          next_check = check.not.or(parent != doc_node.parent).if_true do
            send_message(:next)
          end

          match_node = backup_variable(node, doc_node) do
            process(ast, node, &block).if_true do
              yield(node).followed_by(throw_message(:skip_children))
            end
          end

          doc_compare.followed_by(next_check)
            .followed_by(match_node)
        end

        root_assign.followed_by(parent_if)
          .followed_by(check_assign)
          .followed_by(each_node)
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

        root_assign = orig_input.is_a?(XML::Node)
          .if_true { root.assign(orig_input.root_node) }
          .else    { root.assign(orig_input) }

        check_assign = check.assign(self.false)

        each_node = root.each_node.add_block(doc_node) do
          doc_compare = doc_node.eq(input).if_true do
            check.assign(self.true)
              .followed_by(throw_message(:skip_children))
          end

          next_check = check.not.if_true { send_message(:next) }

          match_node = backup_variable(node, doc_node) do
            process(ast, node, &block).if_true do
              yield node
            end
          end

          doc_compare.followed_by(next_check)
            .followed_by(match_node)
        end

        root_assign.followed_by(check_assign)
          .followed_by(each_node)
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

        root_assign = orig_input.is_a?(XML::Node)
          .if_true { root.assign(orig_input.root_node) }
          .else    { root.assign(orig_input) }

        each_node = root.each_node.add_block(doc_node) do
          compare = doc_node.eq(input).if_true { send_message(:break) }

          match = backup_variable(node, doc_node) do
            process(ast, node, &block).if_true { yield node }
          end

          compare.followed_by(match)
        end

        root_assign.followed_by(each_node)
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

        root_assign = orig_input.is_a?(XML::Node)
          .if_true { root.assign(orig_input.parent) }
          .else    { root.assign(orig_input) }

        check_assign = check.assign(self.false)

        parent_if = input.is_a?(XML::Node).and(input.parent)
          .if_true { parent.assign(input.parent) }
          .else    { parent.assign(self.nil) }

        each_node = root.each_node.add_block(doc_node) do
          compare = doc_node.eq(input).if_true { send_message(:break) }

          match = doc_node.parent.eq(parent).if_true do
            backup_variable(node, doc_node) do
              process(ast, node, &block).if_true { yield node }
            end
          end

          compare.followed_by(match)
        end

        root_assign.followed_by(check_assign)
          .followed_by(parent_if)
          .followed_by(each_node)
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

        inner = process(test, input) do |matched_test_node|
          index_var.eq(index).if_true { yield matched_test_node }
            .followed_by(index_var.assign(index_var + int1))
        end

        index_var.assign(int1).followed_by(inner)
      end

      ##
      # Processes a predicate using an expression.
      #
      # This method generates Ruby code that roughly looks like the following:
      #
      #     if catch :predicate_matched do
      #         node.children.each do |node|
      #
      #         if some_condition_that_matches_a_predicate
      #           throw :predicate_matched, true
      #         end
      #
      #         nil
      #       end
      #
      #       matched.push(node)
      #     end
      #
      # @param [AST::Node] test
      # @param [AST::Node] predicate
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
      def on_expression_predicate(test, predicate, input)
        process(test, input) do |matched_test_node|
          catch_block = catch_message(:predicate_matched) do
            process(predicate, matched_test_node) do
              throw_message(:predicate_matched, self.true)
            end
          end

          catch_block.if_true { yield matched_test_node }
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
        conversion = literal(XPath::Conversion)

        operator(ast, input) do |left, right|
          compatible_assign = mass_assign(
            [left, right],
            conversion.to_compatible_types(left, right)
          )

          operation = left.eq(right)
          operation = operation.if_true(&block) if block # In a predicate

          compatible_assign.followed_by(operation)
        end
      end

      ##
      # Processes the `!=` operator.
      #
      # @see [#operator]
      #
      def on_neq(ast, input, &block)
        conversion = literal(XPath::Conversion)

        operator(ast, input) do |left, right|
          compatible_assign = mass_assign(
            [left, right],
            conversion.to_compatible_types(left, right)
          )

          operation = left != right
          operation = operation.if_true(&block) if block # In a predicate

          compatible_assign.followed_by(operation)
        end
      end

      OPERATORS.each do |callback, (conv_method, ruby_method)|
        define_method(callback) do |ast, input, &block|
          conversion = literal(XPath::Conversion)

          operator(ast, input) do |left, right|
            lval      = conversion.__send__(conv_method, left)
            rval      = conversion.__send__(conv_method, right)
            operation = lval.__send__(ruby_method, rval)

            # In a predicate
            if block
              operation = conversion.to_boolean(operation).if_true(&block)
            end

            operation
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
        conversion = literal(XPath::Conversion)

        left_push = process(left, input) do |node|
          union << node
        end

        right_push = process(right, input) do |node|
          union << node
        end

        push_ast = union.assign(literal(XML::NodeSet).new)
          .followed_by(left_push)
          .followed_by(right_push)

        # In a predicate
        if block
          final = conversion.to_boolean(union).if_true(&block)
        else
          final = union
        end

        push_ast.followed_by(final)
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

        initial_assign = call_arg.assign(arg_ast)
        float_assign   = call_arg.assign(conversion.to_float(call_arg))

        if_nan = call_arg.nan?
          .if_true { call_arg }
          .else    { call_arg.ceil.to_f }

        initial_assign.followed_by(float_assign)
          .followed_by(if_nan)
      end

      # @param [Oga::Ruby::Node] input
      # @param [AST::Node] arg
      # @return [Oga::Ruby::Node]
      def on_call_floor(input, arg)
        arg_ast    = try_match_first_node(arg, input)
        call_arg   = unique_literal(:call_arg)
        conversion = literal(Conversion)

        initial_assign = call_arg.assign(arg_ast)
        float_assign   = call_arg.assign(conversion.to_float(call_arg))

        if_nan = call_arg.nan?
          .if_true { call_arg }
          .else    { call_arg.floor.to_f }

        initial_assign.followed_by(float_assign)
          .followed_by(if_nan)
      end

      # @param [Oga::Ruby::Node] input
      # @param [AST::Node] arg
      # @return [Oga::Ruby::Node]
      def on_call_round(input, arg)
        arg_ast    = try_match_first_node(arg, input)
        call_arg   = unique_literal(:call_arg)
        conversion = literal(Conversion)

        initial_assign = call_arg.assign(arg_ast)
        float_assign   = call_arg.assign(conversion.to_float(call_arg))

        if_nan = call_arg.nan?
          .if_true { call_arg }
          .else    { call_arg.round.to_f }

        initial_assign.followed_by(float_assign)
          .followed_by(if_nan)
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

        haystack_ast = try_match_first_node(haystack, input)
        needle_ast   = try_match_first_node(needle, input)

        include_call = conversion.to_string(haystack_lit)
          .include?(conversion.to_string(needle_lit))

        haystack_lit.assign(haystack_ast)
          .followed_by(needle_lit.assign(needle_ast))
          .followed_by(include_call)
      end

      # @param [Oga::Ruby::Node] input
      # @param [AST::Node] arg
      # @return [Oga::Ruby::Node]
      def on_call_count(input, arg)
        count  = unique_literal(:count)
        assign = count.assign(literal('0.0'))

        unless return_nodeset?(arg)
          raise TypeError, 'count() can only operate on NodeSet instances'
        end

        increment = process(arg, input) do
          count.assign(count + literal('1'))
        end

        assign.followed_by(increment)
          .followed_by(count)
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

      ##
      # Processes the `comment()` type test.
      #
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
      def on_type_test_comment(input)
        input.is_a?(XML::Comment)
      end

      ##
      # Processes the `text()` type test.
      #
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
      def on_type_test_text(input)
        input.is_a?(XML::Text)
      end

      ##
      # Processes the `processing-instruction()` type test.
      #
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
      def on_type_test_processing_instruction(input)
        input.is_a?(XML::ProcessingInstruction)
      end

      ##
      # Processes the `node()` type test.
      #
      # @param [Oga::Ruby::Node] input
      # @return [Oga::Ruby::Node]
      #
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

        blockval = yield left_var, right_var

        initial_assign.followed_by(blockval)
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

      ##
      # @param [Array] vars The variables to assign.
      # @param [Oga::Ruby::Node] value
      # @return [Oga::Ruby::Node]
      #
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

      # @param [AST::Node] ast
      # @return [TrueClass|FalseClass]
      def return_nodeset?(ast)
        RETURN_NODESET.include?(ast.type)
      end
    end # Compiler
  end # XPath
end # Oga
