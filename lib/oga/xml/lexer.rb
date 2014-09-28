module Oga
  module XML
    ##
    # Low level lexer that supports both XML and HTML (using an extra option).
    # To lex HTML input set the `:html` option to `true` when creating an
    # instance of the lexer:
    #
    #     lexer = Oga::XML::Lexer.new(:html => true)
    #
    # This lexer can process both String and IO instances. IO instances are
    # processed on a line by line basis. This can greatly reduce memory usage
    # in exchange for a slightly slower runtime.
    #
    # ## Thread Safety
    #
    # Since this class keeps track of an internal state you can not use the
    # same instance between multiple threads at the same time. For example, the
    # following will not work reliably:
    #
    #     # Don't do this!
    #     lexer   = Oga::XML::Lexer.new('....')
    #     threads = []
    #
    #     2.times do
    #       threads << Thread.new do
    #         lexer.advance do |*args|
    #           p args
    #         end
    #       end
    #     end
    #
    #     threads.each(&:join)
    #
    # However, it is perfectly save to use different instances per thread.
    # There is no _global_ state used by this lexer.
    #
    # @!attribute [r] html
    #  @return [TrueClass|FalseClass]
    #
    class Lexer
      attr_reader :html

      ##
      # @param [String|IO] data The data to lex. This can either be a String or
      #  an IO instance.
      #
      # @param [Hash] options
      #
      # @option options [Symbol] :html When set to `true` the lexer will treat
      #  the input as HTML instead of SGML/XML. This makes it possible to lex
      #  HTML void elements such as `<link href="">`.
      #
      def initialize(data, options = {})
        @data = data
        @html = options[:html]

        reset
      end

      ##
      # Resets the internal state of the lexer. Typically you don't need to
      # call this method yourself as its called by #lex after lexing a given
      # String.
      #
      def reset
        @line     = 1
        @elements = []

        @data.rewind if io_input?

        reset_native
      end

      ##
      # Yields the data to lex to the supplied block.
      #
      # @return [String]
      # @yieldparam [String]
      #
      def read_data
        # We can't check for #each_line since String also defines that. Using
        # String#each_line has no benefit over just lexing the String in one
        # go.
        if io_input?
          @data.each_line do |line|
            yield line
          end
        else
          yield @data
        end
      end

      ##
      # Returns `true` if the input is an IO like object, false otherwise.
      #
      # @return [TrueClass|FalseClass]
      #
      def io_input?
        return @data.is_a?(IO) || @data.is_a?(StringIO)
      end

      ##
      # Gathers all the tokens for the input and returns them as an Array.
      #
      # This method resets the internal state of the lexer after consuming the
      # input.
      #
      # @see #advance
      # @return [Array]
      #
      def lex
        tokens = []

        advance do |type, value, line|
          tokens << [type, value, line]
        end

        reset

        return tokens
      end

      ##
      # Advances through the input and generates the corresponding tokens. Each
      # token is yielded to the supplied block.
      #
      # Each token is an Array in the following format:
      #
      #     [TYPE, VALUE]
      #
      # The type is a symbol, the value is either nil or a String.
      #
      # This method stores the supplied block in `@block` and resets it after
      # the lexer loop has finished.
      #
      # This method does *not* reset the internal state of the lexer.
      #
      # @yieldparam [Symbol] type
      # @yieldparam [String] value
      # @yieldparam [Fixnum] line
      #
      def advance(&block)
        @block = block

        read_data do |chunk|
          advance_native(chunk)
        end
      ensure
        @block = nil
      end

      ##
      # @return [TrueClass|FalseClass]
      #
      def html?
        return !!html
      end

      private

      ##
      # @param [Fixnum] amount The amount of lines to advance.
      #
      def advance_line(amount = 1)
        @line += amount
      end

      ##
      # Calls the supplied block with the information of the current token.
      #
      # @param [Symbol] type The token type.
      # @param [String] value The token value.
      #
      # @yieldparam [String] type
      # @yieldparam [String] value
      # @yieldparam [Fixnum] line
      #
      def add_token(type, value = nil)
        @block.call(type, value, @line)
      end

      ##
      # Returns the name of the element we're currently in.
      #
      # @return [String]
      #
      def current_element
        return @elements.last
      end

      ##
      # Called when processing single/double quoted strings.
      #
      # @param [String] value The data between the quotes.
      #
      def on_string(value)
        add_token(:T_STRING, Entities.decode(value))
      end

      ##
      # Called when a doctype starts.
      #
      def on_doctype_start
        add_token(:T_DOCTYPE_START)
      end

      ##
      # Called on the identifier specifying the type of the doctype.
      #
      # @param [String] value
      #
      def on_doctype_type(value)
        add_token(:T_DOCTYPE_TYPE, value)
      end

      ##
      # Called on the identifier specifying the name of the doctype.
      #
      # @param [String] value
      #
      def on_doctype_name(value)
        add_token(:T_DOCTYPE_NAME, value)
      end

      ##
      # Called on the end of a doctype.
      #
      def on_doctype_end
        add_token(:T_DOCTYPE_END)
      end

      ##
      # Called on an inline doctype block.
      #
      # @param [String] value
      #
      def on_doctype_inline(value)
        add_token(:T_DOCTYPE_INLINE, value)
      end

      ##
      # Called on a CDATA tag.
      #
      def on_cdata(value)
        add_token(:T_CDATA, value)
      end

      ##
      # Called on a comment.
      #
      # @param [String] value
      #
      def on_comment(value)
        add_token(:T_COMMENT, value)
      end

      ##
      # Called on the start of an XML declaration tag.
      #
      def on_xml_decl_start
        add_token(:T_XML_DECL_START)
      end

      ##
      # Called on the end of an XML declaration tag.
      #
      def on_xml_decl_end
        add_token(:T_XML_DECL_END)
      end

      ##
      # Called on the start of an element.
      #
      def on_element_start
        add_token(:T_ELEM_START)
      end

      ##
      # Called on the start of a processing instruction.
      #
      def on_proc_ins_start
        add_token(:T_PROC_INS_START)
      end

      ##
      # Called on a processing instruction name.
      #
      # @param [String] value
      #
      def on_proc_ins_name(value)
        add_token(:T_PROC_INS_NAME, value)
      end

      ##
      # Called on the end of a processing instruction.
      #
      def on_proc_ins_end
        add_token(:T_PROC_INS_END)
      end

      ##
      # Called on the name of an element.
      #
      # @param [String] name The name of the element, including namespace.
      #
      def on_element_name(name)
        @elements << name if html?

        add_token(:T_ELEM_NAME, name)
      end

      ##
      # Called on the element namespace.
      #
      # @param [String] namespace
      #
      def on_element_ns(namespace)
        add_token(:T_ELEM_NS, namespace)
      end

      ##
      # Called on the closing `>` of the open tag of an element.
      #
      def on_element_open_end
        return unless html?

        # Only downcase the name if we can't find an all lower/upper version of
        # the element name. This can save us a *lot* of String allocations.
        if HTML_VOID_ELEMENTS.include?(current_element) \
        or HTML_VOID_ELEMENTS.include?(current_element.downcase)
          add_token(:T_ELEM_END)
          @elements.pop
        end
      end

      ##
      # Called on the closing tag of an element.
      #
      def on_element_end
        add_token(:T_ELEM_END)

        @elements.pop if html?
      end

      ##
      # Called on regular text values.
      #
      # @param [String] value
      #
      def on_text(value)
        return if value.empty?

        add_token(:T_TEXT, Entities.decode(value))
      end

      ##
      # Called on attribute namespaces.
      #
      # @param [String] value
      #
      def on_attribute_ns(value)
        add_token(:T_ATTR_NS, value)
      end

      ##
      # Called on tag attributes.
      #
      # @param [String] value
      #
      def on_attribute(value)
        add_token(:T_ATTR, value)
      end
    end # Lexer
  end # XML
end # Oga
