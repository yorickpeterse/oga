module Oga
  module XML
    ##
    # Names of the HTML void elements that should be handled when HTML lexing
    # is enabled.
    #
    # @return [Set]
    #
    HTML_VOID_ELEMENTS = Set.new([
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

    HTML_VOID_ELEMENTS.merge(HTML_VOID_ELEMENTS.map { |name| name.upcase })
  end # XML
end # Oga
