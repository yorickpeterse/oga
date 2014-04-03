module Oga
  module XML
    ##
    # Class description
    #
    class Document
      attr_accessor :children, :doctype, :xml_declaration

      ##
      # @param [Hash] options
      #
      def initialize(options = {})
        options.each do |key, value|
          instance_variable_set("@#{key}", value) if respond_to?(key)
        end

        @children ||= []
      end

      def to_xml
        xml = children.map(&:to_xml).join('')

        if doctype
          xml = doctype.to_xml + "\n" + xml.strip
        end

        if xml_declaration
          xml = xml_declaration.to_xml + "\n" + xml.strip
        end

        return xml
      end

      def inspect
        class_name  = self.class.to_s.split('::').last
        child_lines = children.map { |child| child.inspect(4) }.join("\n")

        return <<-EOF.strip
#{class_name}(
  doctype: #{doctype.inspect}
  xml_declaration: #{xml_declaration.inspect}
  children: [
#{child_lines}
])
        EOF
      end
    end # Document
  end # XML
end # Oga
