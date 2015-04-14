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
    # @see [Oga::XML::NodeSet#initialize]
    #
    def node_set(*args)
      return Oga::XML::NodeSet.new(args)
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
    # @see [#lex]
    #
    def lex_stringio(input, options = {})
      return lex(StringIO.new(input), options)
    end

    ##
    # @see [#lex]
    #
    def lex_html(input)
      return Oga::XML::Lexer.new(input, :html => true).lex
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
    rescue LL::ParserError => error
      return error.message
    end
  end # ParsingHelpers
end # Oga
