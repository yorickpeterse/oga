module Oga
  module XML
    ##
    # Class description
    #
    class Document < Node
      attr_accessor :xml_declaration

      def to_xml
        xml = children.map(&:to_xml).join('')

        if xml_declaration
          xml = xml_declaration.to_xml + xml
        end

        return xml
      end
    end # Document
  end # XML
end # Oga
