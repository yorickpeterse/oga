module Oga
  module XML
    ##
    # The SaxParser class provides the basic interface for writing custom SAX
    # parsers. All callback methods defined in {Oga::XML::Parser} are delegated
    # to a dedicated handler class.
    #
    # To write a custom handler for the SAX parser, create a class that
    # implements one (or many) of the following callback methods:
    #
    # * `on_document`
    # * `on_doctype`
    # * `on_cdata`
    # * `on_comment`
    # * `on_proc_ins`
    # * `on_xml_decl`
    # * `on_text`
    # * `on_element`
    # * `on_element_children`
    # * `after_element`
    #
    # For example:
    #
    #     class SaxHandler
    #       def on_element(namespace, name, attrs = {})
    #         puts name
    #       end
    #     end
    #
    # You can then use it as following:
    #
    #     handler = SaxHandler.new
    #     parser  = Oga::XML::SaxParser.new(handler, '<foo />')
    #
    #     parser.parse
    #
    # For information on the callback arguments see the documentation of the
    # corresponding methods in {Oga::XML::Parser}.
    #
    class SaxParser < Parser
      ##
      # @param [Object] handler The SAX handler to delegate callbacks to.
      # @see [Oga::XML::Parser#initialize]
      #
      def initialize(handler, *args)
        @handler = handler

        super(*args)
      end

      # Delegate all callbacks to the handler object.
      instance_methods.grep(/^(on_|after_)/).each do |method|
        eval <<-EOF, nil, __FILE__, __LINE__ + 1
        def #{method}(*args)
          @handler.#{method}(*args) if @handler.respond_to?(:#{method})

          return
        end
        EOF
      end
    end # SaxParser
  end # XML
end # Oga
