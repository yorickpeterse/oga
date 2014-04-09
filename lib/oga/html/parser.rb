module Oga
  module HTML
    ##
    # Low level AST parser for parsing HTML documents. See {Oga::XML::Parser}
    # for more information.
    #
    class Parser < XML::Parser
      ##
      # @param [String] data
      # @param [Hash] options
      # @see Oga::XML::Parser#initialize
      #
      def initialize(data, options = {})
        options = options.merge(:html => true)

        super(data, options)
      end
    end # Parser
  end # HTML
end # Oga
