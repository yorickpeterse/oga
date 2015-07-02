module Oga
  module Ruby
    ##
    # Class for converting a Ruby AST to a String.
    #
    # This class takes a {Oga::Ruby::Node} instance and converts it (and its
    # child nodes) to a String that in turn can be passed to `eval` and the
    # likes.
    #
    class Generator
      ##
      # @param [Oga::Ruby::Node] ast
      # @return [String]
      #
      def process(ast)
        send(:"on_#{ast.type}", ast)
      end

      ##
      # Processes a "begin" node.
      #
      # @param [Oga::Ruby::Node] ast
      # @return [String]
      #
      def on_begin(ast)
        ast.to_a.map { |child| process(child) }.join("\n\n")
      end

      ##
      # Processes an assignment node.
      #
      # @param [Oga::Ruby::Node] ast
      # @return [String]
      #
      def on_assign(ast)
        var, val = *ast

        var_str = process(var)
        val_str = process(val)

        "#{var_str} = #{val_str}"
      end

      ##
      # Processes an equality node.
      #
      # @param [Oga::Ruby::Node] ast
      # @return [String]
      #
      def on_eq(ast)
        left, right = *ast

        left_str  = process(left)
        right_str = process(right)

        "#{left_str} == #{right_str}"
      end

      ##
      # Processes a boolean "and" node.
      #
      # @param [Oga::Ruby::Node] ast
      # @return [String]
      #
      def on_and(ast)
        left, right = *ast

        left_str  = process(left)
        right_str = process(right)

        "#{left_str} && #{right_str}"
      end

      ##
      # Processes a boolean "or" node.
      #
      # @param [Oga::Ruby::Node] ast
      # @return [String]
      #
      def on_or(ast)
        left, right = *ast

        left_str  = process(left)
        right_str = process(right)

        "(#{left_str} || #{right_str})"
      end

      ##
      # Processes an if statement node.
      #
      # @param [Oga::Ruby::Node] ast
      # @return [String]
      #
      def on_if(ast)
        cond, body = *ast

        cond_str = process(cond)
        body_str = process(body)

        <<-EOF
if #{cond_str}
  #{body_str}
end
        EOF
      end

      ##
      # Processes a method call node.
      #
      # @param [Oga::Ruby::Node] ast
      # @return [String]
      #
      def on_send(ast)
        receiver, name, *args = *ast

        call = name.dup

        unless args.empty?
          arg_strs = args.map { |arg| process(arg) }
          call     = "#{call}(#{arg_strs.join(', ')})"
        end

        if receiver
          call = "#{process(receiver)}.#{call}"
        end

        call
      end

      ##
      # Processes a block node.
      #
      # @param [Oga::Ruby::Node] ast
      # @return [String]
      #
      def on_block(ast)
        receiver, args, body = *ast

        receiver_str = process(receiver)
        body_str     = body ? process(body) : nil
        arg_strs     = args.map { |arg| process(arg) }

        <<-EOF
#{receiver_str} do |#{arg_strs.join(', ')}|
  #{body_str}
end
        EOF
      end

      ##
      # Processes a string node.
      #
      # @param [Oga::Ruby::Node] ast
      # @return [String]
      #
      def on_string(ast)
        ast.to_a[0].inspect
      end

      ##
      # Processes a literal node.
      #
      # @param [Oga::Ruby::Node] ast
      # @return [String]
      #
      def on_lit(ast)
        ast.to_a[0]
      end
    end # Generator
  end # Ruby
end # Oga
