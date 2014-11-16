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
    # ## Element Callbacks
    #
    # The SAX parser changes the behaviour of both `on_element` and
    # `after_element`. The latter in the regular parser only takes a
    # {Oga::XML::Element} instance. In the SAX parser it will instead take a
    # namespace name and the element name. This eases the process of figuring
    # out what element a callback is associated with.
    #
    # An example:
    #
    #     class SaxHandler
    #       def on_element(namespace, name, attrs = {})
    #         # ...
    #       end
    #
    #       def after_element(namespace, name)
    #         puts name # => "foo", "bar", etc
    #       end
    #     end
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
          run_callback(:#{method}, *args)

          return
        end
        EOF
      end

      ##
      # Manually overwrite `on_element` so we can ensure that `after_element`
      # always receives the namespace and name.
      #
      # @see [Oga::XML::Parser#on_element]
      # @return [Array]
      #
      def on_element(namespace, name, attrs = {})
        run_callback(:on_element, namespace, name, attrs)

        return namespace, name
      end

      ##
      # Manually overwrite `after_element` so it can take a namespace and name.
      # This differs a bit from the regular `after_element` which only takes an
      # {Oga::XML::Element} instance.
      #
      # @param [Array] namespace_with_name
      #
      def after_element(namespace_with_name)
        run_callback(:after_element, *namespace_with_name)
      end

      private

      ##
      # @param [Symbol] method
      # @param [Array] args
      #
      def run_callback(method, *args)
        @handler.send(method, *args) if @handler.respond_to?(method)
      end
    end # SaxParser
  end # XML
end # Oga
