module Oga
  module XML
    ##
    # Class that contains information about an XML element such as the name,
    # attributes and child nodes.
    #
    class Element < Node
      ##
      # @param [String] name The name of the element
      # @see Oga::XML::Node#initialize
      #
      def initialize(name, options = {})
        super(options)

        @name = name
      end
    end # Element
  end # XML
end # Oga
