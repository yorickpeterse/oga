module Oga
  module XML
    ##
    # Names of the HTML void elements that should be handled when HTML lexing
    # is enabled.
    #
    # @return [Oga::NodeNameSet]
    #
    HTML_VOID_ELEMENTS = NodeNameSet.new([
      'area',
      'base',
      'br',
      'col',
      'command',
      'embed',
      'hr',
      'img',
      'input',
      'keygen',
      'link',
      'meta',
      'param',
      'source',
      'track',
      'wbr'
    ])
  end # XML
end # Oga
