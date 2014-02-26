module Oga
  module ParsingHelpers
    ##
    # Builds an AST node.
    #
    # @param [Symbol] type
    # @param [Array] cihldren
    # @return [Oga::AST::Node]
    #
    def s(type, *children)
      return Oga::AST::Node.new(type, children)
    end
  end # ParsingHelpers
end # Oga
