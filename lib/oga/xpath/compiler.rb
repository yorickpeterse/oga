module Oga
  module XPath
    ##
    # Compiling of XPath ASTs into Ruby source code.
    #
    # The Compiler class can be used to turn an XPath AST into Ruby source code
    # that can be executed to match XML nodes in a given input document/element.
    # Compiled source code is cached per expression, removing the need for
    # recompiling the same expression over and over again.
    #
    class Compiler
    end # Compiler
  end # XPath
end # Oga
