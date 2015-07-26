module Oga
  module XPath
    ##
    # Module for converting XPath objects such as NodeSets.
    #
    module Conversion
      ##
      # Converts both arguments to a type that can be compared using ==.
      #
      # @return [Array]
      #
      def self.to_compatible_types(left, right)
        if left.is_a?(XML::NodeSet)
          left = to_string(left)
        end

        if right.is_a?(XML::NodeSet)
          right = to_string(right)
        end

        if left.is_a?(Numeric) and !right.is_a?(Numeric)
          right = to_float(right)
        end

        if left.is_a?(String) and !right.is_a?(String)
          right = to_string(right)
        end

        if boolean?(left) and !boolean?(right)
          right = to_boolean(right)
        end

        [left, right]
      end

      # @return [String]
      def self.to_string(value)
        # If we have a number that has a zero decimal (e.g. 10.0) we want to
        # get rid of that decimal. For this we'll first convert the number to
        # an integer.
        if value.is_a?(Float) and value.modulo(1).zero?
          value = value.to_i
        end

        if value.is_a?(XML::NodeSet)
          first = value.first
          value = first.respond_to?(:text) ? first.text : ''
        end

        if value.respond_to?(:text)
          value = value.text
        end

        value.to_s
      end

      # @return [Float]
      def self.to_float(value)
        Float(value) rescue Float::NAN
      end

      # @return [TrueClass|FalseClass]
      def self.to_boolean(value)
        bool = false

        if value.is_a?(Float)
          bool = !value.nan? && !value.zero?
        elsif value.is_a?(Fixnum)
          bool = !value.zero?
        elsif value.respond_to?(:empty?)
          bool = !value.empty?
        end

        bool
      end

      # @return [TrueClass|FalseClass]
      def self.boolean?(value)
        value.is_a?(TrueClass) || value.is_a?(FalseClass)
      end
    end # Conversion
  end # XPath
end # Oga
