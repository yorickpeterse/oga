module Oga
  module XML
    ##
    # Class containing information about an XML declaration tag.
    #
    class XmlDeclaration
      # @return [String]
      attr_accessor :version

      # @return [String]
      attr_accessor :encoding

      # Whether or not the document is a standalone document.
      # @return [String]
      attr_accessor :standalone

      ##
      # @param [Hash] options
      #
      # @option options [String] :version
      # @option options [String] :encoding
      # @option options [String] :standalone
      #
      def initialize(options = {})
        @version    = options[:version] || '1.0'
        @encoding   = options[:encoding] || 'UTF-8'
        @standalone = options[:standalone]
      end

      ##
      # Converts the declaration tag to XML.
      #
      # @return [String]
      #
      def to_xml
        pairs = []

        [:version, :encoding, :standalone].each do |getter|
          value = send(getter)

          pairs << %Q{#{getter}="#{value}"} if value
        end

        return "<?xml #{pairs.join(' ')} ?>"
      end

      ##
      # @return [String]
      #
      def inspect
        segments = []

        [:version, :encoding, :standalone].each do |attr|
          value = send(attr)

          if value and !value.empty?
            segments << "#{attr}: #{value.inspect}"
          end
        end

        return "XmlDeclaration(#{segments.join(' ')})"
      end
    end # XmlDeclaration
  end # XML
end # Oga
