module Oga
  module ParsingHelpers
    ##
    # Builds an AST node.
    #
    # @param [Symbol] type
    # @param [Array] cihldren
    # @return [AST::Node]
    #
    def s(type, *children)
      return AST::Node.new(type, children)
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
    # Lexes a CSS expression.
    #
    # @param [String] input
    # @return [Array]
    #
    def lex_css(input)
      return Oga::CSS::Lexer.new(input).lex
    end

    ##
    # @param [String] input
    # @return [AST::Node]
    #
    def parse_css(input)
      return Oga::CSS::Parser.new(input).parse
    end

    ##
    # Parses an XPath expression.
    #
    # @param [String] input
    # @return [AST::Node]
    #
    def parse_xpath(input)
      return Oga::XPath::Parser.new(input).parse
    end

    ##
    # @param [String] input
    # @param [Hash] options
    # @return [Oga::XML::Document]
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

    ##
    # Parses and transforms a CSS AST into an XPath AST.
    #
    # @param [String] css
    # @return [AST::Node]
    #
    def transform_css(css)
      ast = parse_css(css)

      return Oga::CSS::Transformer.new.process(ast)
    end
  end # ParsingHelpers
end # Oga
