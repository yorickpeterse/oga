module Oga
  module XML
    ##
    # The PullParser class can be used to parse an XML document incrementally
    # instead of parsing it as a whole. This results in lower memory usage and
    # potentially faster parsing times. The downside is that pull parsers are
    # typically more difficult to use compared to DOM parsers.
    #
    # Basic parsing using this class works as following:
    #
    #     parser = Oga::XML::PullParser.new('... xml here ...')
    #
    #     parser.parse do |node|
    #       if node.is_a?(Oga::XML::PullParser)
    #
    #       end
    #     end
    #
    # This parses yields proper XML instances such as {Oga::XML::Element}.
    # Doctypes and XML declarations are ignored by this parser.
    #
    class PullParser < Parser
      ##
      # @return [Array]
      #
      DISABLED_CALLBACKS = [
        :on_document,
        :on_doctype,
        :on_xml_decl,
        :on_element_children
      ]

      ##
      # @return [Array]
      #
      BLOCK_CALLBACKS = [
        :on_cdata,
        :on_comment,
        :on_text,
        :on_element
      ]

      ##
      # @see Oga::XML::Parser#reset
      #
      def reset
        super

        @block = nil
      end

      ##
      # Parses the input and yields every node to the supplied block.
      #
      # @yieldparam [Oga::XML::Node]
      #
      def parse(&block)
        @block = block

        yyparse(self, :yield_next_token)

        reset

        return
      end

      # eval is a heck of a lot faster than define_method on both Rubinius and
      # JRuby.
      DISABLED_CALLBACKS.each do |method|
        eval <<-EOF, nil, __FILE__, __LINE__ + 1
        def #{method}(*_)
          return
        end
        EOF
      end

      BLOCK_CALLBACKS.each do |method|
        eval <<-EOF, nil, __FILE__, __LINE__ + 1
        def #{method}(*args)
          @block.call(super)
        end
        EOF
      end
    end # PullParser
  end # XML
end # Oga
