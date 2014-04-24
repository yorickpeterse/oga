module Oga
  module XML
    ##
    # Mixin that can be used to link child nodes together with their parent,
    # previous and next following.
    #
    module ChildMixin
      ##
      # Links child nodes together with each other and sets the parent node of
      # each child.
      #
      def link_child_nodes
        amount = children.length

        children.each_with_index do |child, index|
          prev_index = index - 1
          next_index = index + 1

          if index > 0
            child.previous = children[prev_index]
          end

          if next_index <= amount
            child.next = children[next_index]
          end

          child.parent = self
        end
      end
    end # NodeHierarchy
  end # XML
end # Oga
