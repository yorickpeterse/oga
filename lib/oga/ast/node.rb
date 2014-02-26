module Oga
  module AST
    ##
    #
    class Node < ::AST::Node
      attr_reader :line, :column
    end # Node
  end # AST
end # Oga
