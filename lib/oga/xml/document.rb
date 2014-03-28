module Oga
  module XML
    ##
    # Class description
    #
    class Document < Node
      attr_accessor :dtd, :xml_version, :encoding

      def to_xml
        return children.map(&:to_xml).join('')
      end
    end # Document
  end # XML
end # Oga
