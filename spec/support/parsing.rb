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

    ##
    # Lexes a string and returns the tokens.
    #
    # @param [String] input
    # @return [Array]
    #
    def lex(input)
      return Oga::Lexer.new.lex(input)
    end
  end # ParsingHelpers
end # Oga
