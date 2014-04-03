module Oga
  module XML
    ##
    # Class description
    #
    class Document
      attr_accessor :children, :doctype, :xml_declaration

      ##
      # @param [Hash] options
      #
      def initialize(options = {})
        options.each do |key, value|
          instance_variable_set("@#{key}", value) if respond_to?(key)
        end

        @children ||= []
      end

      def to_xml
        xml = children.map(&:to_xml).join('')

        if doctype
          xml = doctype.to_xml + xml
        end

        if xml_declaration
          xml = xml_declaration.to_xml + xml
        end

        return xml
      end
    end # Document
  end # XML
end # Oga
