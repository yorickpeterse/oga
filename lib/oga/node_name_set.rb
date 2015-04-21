module Oga
  ##
  # Class for storing (HTML) element names in a set and automatically adding
  # their uppercase equivalents.
  #
  class NodeNameSet < Set
    ##
    # @param [Array] values
    #
    def initialize(values = [])
      values = values + values.map(&:upcase)

      super(values)
    end
  end # NodeNameSet
end # Oga
