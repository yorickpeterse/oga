module Oga
  module XML
    ##
    # Class containing information about an XML declaration tag.
    #
    # @!attribute [rw] version
    #  The XML version.
    #  @return [String]
    #
    # @!attribute [rw] encoding
    #  The XML document's encoding.
    #  @return [String]
    #
    # @!attribute [rw] standalone
    #  Whether or not the document is a standalone document.
    #  @return [String]
    #
    class XmlDeclaration
      attr_accessor :version, :encoding, :standalone

      ##
      # @param [Hash] options
      #
      # @option options [String] :version
      # @option options [String] :encoding
      # @option options [String] :standalone
      #
      def initialize(options = {})
        options.each do |key, value|
          instance_variable_set("@#{key}", value) if respond_to?(key)
        end

        @version  ||= '1.0'
        @encoding ||= 'UTF-8'
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
      # @param [Fixnum] indent
      # @return [String]
      #
      def inspect(indent = 0)
        class_name = self.class.to_s.split('::').last
        spacing    = ' ' * indent

        return <<-EOF.strip
#{class_name}(
#{spacing}  version: #{version.inspect}
#{spacing}  encoding: #{encoding.inspect}
#{spacing}  standalone: #{standalone.inspect}
#{spacing})
        EOF
      end
    end # XmlDeclaration
  end # XML
end # Oga
