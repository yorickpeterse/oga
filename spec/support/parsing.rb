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
    # @param [Hash] options
    # @return [Array]
    #
    def lex(input, options = {})
      return Oga::XML::Lexer.new(input, options).lex
    end

    ##
    # Lexes an XPath expression.
    #
    # @param [String] input
    # @return [Array]
    #
    def lex_xpath(input)
      return Oga::XPath::Lexer.new(input).lex
    end

    ##
    # Parses the given XML and returns an AST.
    #
    # @param [String] input
    # @param [Hash] options
    # @return [Oga::AST::Node]
    #
    def parse(input, options = {})
      return Oga::XML::Parser.new(input, options).parse
    end

    ##
    # Parses the given HTML and returns an AST.
    #
    # @see #parse
    #
    def parse_html(input, options = {})
      return Oga::HTML::Parser.new(input, options).parse
    end

    ##
    # Parses the given invalid XML and returns the error message.
    #
    # @param [String] xml
    # @return [String]
    #
    def parse_error(xml)
      parse(xml)
    rescue Racc::ParseError => error
      return error.message
    end
  end # ParsingHelpers
end # Oga
