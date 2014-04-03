module Oga
  module XML
    ##
    # Class description
    #
    class Doctype
      attr_accessor :name, :type, :public_id, :system_id

      ##
      # @param [Hash] options
      #
      def initialize(options = {})
        options.each do |key, value|
          instance_variable_set("@#{key}", value) if respond_to?(key)
        end
      end

      def to_xml
        segments = "<!DOCTYPE #{name}"

        segments << " #{type}" if type
        segments << %Q{ "#{public_id}"} if public_id
        segments << %Q{ "#{system_id}"} if system_id

        return segments + '>'
      end

      def inspect(indent = 0)
        class_name = self.class.to_s.split('::').last

        return <<-EOF.strip
#{class_name}(
    name: #{name.inspect}
    type: #{type.inspect}
    public_id: #{public_id.inspect}
    system_id: #{system_id.inspect}
  )
        EOF
      end
    end # Doctype
  end # XML
end # Oga
