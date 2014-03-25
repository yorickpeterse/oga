module Oga
  module HTML
    ##
    # Low level AST parser for parsing HTML documents. See {Oga::XML::Parser}
    # for more information.
    #
    class Parser < XML::Parser
      ##
      # @param [Hash] options
      # @see Oga::XML::Parser#initialize
      #
      def initialize(options = {})
        options = options.merge(:html => true)

        super(options)
      end
    end # Parser
  end # HTML
end # Oga
