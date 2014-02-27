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

    ##
    # Parses the given HTML and returns an AST.
    #
    # @param [String] input
    # @return [Oga::AST::Node]
    #
    def parse_html(input)
      return Oga::Parser::HTML.new.parse(input)
    end
  end # ParsingHelpers
end # Oga
