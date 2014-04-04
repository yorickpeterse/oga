module Oga
  module XML
    ##
    #
    #
    class XmlDeclaration
      attr_accessor :version, :encoding, :standalone

      ##
      # @param [Hash] options
      #
      # @option options [String] :version The XML version.
      # @option options [String] :encoding The XML encoding.
      # @option options [String] :standalone
      #
      def initialize(options = {})
        options.each do |key, value|
          instance_variable_set("@#{key}", value) if respond_to?(key)
        end

        @version  ||= '1.0'
        @encoding ||= 'UTF-8'
      end

      def to_xml
        pairs = []

        [:version, :encoding, :standalone].each do |getter|
          value = send(getter)

          pairs << %Q{#{getter}="#{value}"} if value
        end

        return "<?xml #{pairs.join(' ')} ?>"
      end


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
