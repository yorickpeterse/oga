module Oga
  module EntityDecoder
    ##
    # @see [decode]
    #
    def self.try_decode(input, html = false)
      return input ? decode(input, html) : nil
    end

    ##
    # @param [String] input
    # @param [TrueClass|FalseClass] html
    # @return [String]
    #
    def self.decode(input, html = false)
      decoder = html ? HTML::Entities : XML::Entities

      return decoder.decode(input)
    end
  end # EntityDecoder
end # Oga
