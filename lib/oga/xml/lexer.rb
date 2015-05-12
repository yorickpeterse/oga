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

      # These are all constant/frozen to remove the need for String allocations
      # every time they are referenced in the lexer.
      HTML_SCRIPT = 'script'.freeze
      HTML_STYLE  = 'style'.freeze

      # Elements that should be closed automatically before a new opening tag is
      # processed.
      HTML_CLOSE_SELF = {
        'html'     => NodeNameSet.new(%w{html}),
        'head'     => NodeNameSet.new(%w{head body}),
        'body'     => NodeNameSet.new(%w{body head}),
        'base'     => NodeNameSet.new(%w{base}),
        'link'     => NodeNameSet.new(%w{link}),
        'meta'     => NodeNameSet.new(%w{meta}),
        'noscript' => NodeNameSet.new(%w{noscript}),
        'template' => NodeNameSet.new(%w{template}),
        'title'    => NodeNameSet.new(%w{title}),
        'li'       => NodeNameSet.new(%w{li}),
        'dt'       => NodeNameSet.new(%w{dt dd}),
        'dd'       => NodeNameSet.new(%w{dd dt}),
        'rb'       => NodeNameSet.new(%w{rb rt rtc rp}),
        'rt'       => NodeNameSet.new(%w{rb rt rtc rp}),
        'rtc'      => NodeNameSet.new(%w{rb rtc rp}),
        'rp'       => NodeNameSet.new(%w{rb rt rtc rp}),
        'optgroup' => NodeNameSet.new(%w{optgroup}),
        'option'   => NodeNameSet.new(%w{option optgroup}),
        'colgroup' => NodeNameSet.new(%w{thead tbody tfoot colgroup tr}),
        'caption'  => NodeNameSet.new(%w{thead tbody tfoot colgroup tr caption}),
        'thead'    => NodeNameSet.new(%w{thead tbody tfoot}),
        'tbody'    => NodeNameSet.new(%w{thead tbody tfoot}),
        'tfoot'    => NodeNameSet.new(%w{thead tbody tfoot}),
        'tr'       => NodeNameSet.new(%w{tr tbody thead tfoot}),
        'td'       => NodeNameSet.new(%w{td th tbody thead tfoot tr}),
        'th'       => NodeNameSet.new(%w{td th tbody thead tfoot tr}),
        'p'        => NodeNameSet.new(%w{
          address article aside blockquote div dl fieldset footer form h1 h2 h3
          h4 h5 h6 header hgroup hr main nav ol p pre section table ul
        })
      }

      HTML_CLOSE_SELF.keys.each do |key|
        HTML_CLOSE_SELF[key.upcase] = HTML_CLOSE_SELF[key]
      end

      ##
      # Names of HTML tags of which the content should be lexed as-is.
      #
      LITERAL_HTML_ELEMENTS = NodeNameSet.new([HTML_SCRIPT, HTML_STYLE])

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

        @data.rewind if @data.respond_to?(:rewind)

        reset_native
      end

      ##
      # Yields the data to lex to the supplied block.
      #
      # @return [String]
      # @yieldparam [String]
      #
      def read_data
        if @data.is_a?(String)
          yield @data

        # IO, StringIO, etc
        # THINK: read(N) would be nice, but currently this screws up the C code
        elsif @data.respond_to?(:each_line)
          @data.each_line { |line| yield line }

        # Enumerator, Array, etc
        elsif @data.respond_to?(:each)
          @data.each { |chunk| yield chunk }
        end
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

        # Add any missing closing tags
        unless @elements.empty?
          @elements.length.times { on_element_end }
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

      ##
      # @return [TrueClass|FalseClass]
      #
      def html_script?
        return html? && current_element == HTML_SCRIPT
      end

      ##
      # @return [TrueClass|FalseClass]
      #
      def html_style?
        return html? && current_element == HTML_STYLE
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
      # Called when processing a single quote.
      #
      def on_string_squote
        add_token(:T_STRING_SQUOTE)
      end

      ##
      # Called when processing a double quote.
      #
      def on_string_dquote
        add_token(:T_STRING_DQUOTE)
      end

      ##
      # Called when processing the body of a string.
      #
      # @param [String] value The data between the quotes.
      #
      def on_string_body(value)
        add_token(:T_STRING_BODY, value)
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
      # Called on the open CDATA tag.
      #
      def on_cdata_start
        add_token(:T_CDATA_START)
      end

      ##
      # Called on the closing CDATA tag.
      #
      def on_cdata_end
        add_token(:T_CDATA_END)
      end

      ##
      # Called for the body of a CDATA tag.
      #
      # @param [String] value
      #
      def on_cdata_body(value)
        add_token(:T_CDATA_BODY, value)
      end

      ##
      # Called on the open comment tag.
      #
      def on_comment_start
        add_token(:T_COMMENT_START)
      end

      ##
      # Called on the closing comment tag.
      #
      def on_comment_end
        add_token(:T_COMMENT_END)
      end

      ##
      # Called on a comment.
      #
      # @param [String] value
      #
      def on_comment_body(value)
        add_token(:T_COMMENT_BODY, value)
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
      # Called on the body of a processing instruction.
      #
      # @param [String] value
      #
      def on_proc_ins_body(value)
        add_token(:T_PROC_INS_BODY, value)
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
        before_html_element_name(name) if html?

        add_element(name)
      end

      ##
      # Handles inserting of any missing tags whenever a new HTML tag is opened.
      #
      # @param [String] name
      #
      def before_html_element_name(name)
        close_current = HTML_CLOSE_SELF[current_element]

        if close_current and close_current.include?(name)
          on_element_end
        end

        # Close remaining parent elements. This for example ensures that a
        # "<tbody>" not only closes an unclosed "<th>" but also the surrounding,
        # unclosed "<tr>".
        while close_current = HTML_CLOSE_SELF[current_element]
          if close_current.include?(name)
            on_element_end
          else
            break
          end
        end
      end

      ##
      # @param [String] name
      #
      def add_element(name)
        @elements << name

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
        return if @elements.empty?

        add_token(:T_ELEM_END)

        @elements.pop
      end

      ##
      # Called on regular text values.
      #
      # @param [String] value
      #
      def on_text(value)
        return if value.empty?

        add_token(:T_TEXT, value)
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
