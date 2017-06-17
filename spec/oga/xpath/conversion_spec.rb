require 'spec_helper'

describe Oga::XPath::Conversion do
  describe 'to_compatible_types' do
    it 'returns two Strings when using two NodeSets' do
      set1 = node_set(Oga::XML::Text.new(:text => 'foo'))
      set2 = node_set(Oga::XML::Text.new(:text => 'bar'))

      left, right = described_class.to_compatible_types(set1, set2)

      expect(left).to  eq('foo')
      expect(right).to eq('bar')
    end

    it 'returns two Strings when using two Nodes' do
      n1 = Oga::XML::Text.new(:text => 'foo')
      n2 = Oga::XML::Text.new(:text => 'bar')

      left, right = described_class.to_compatible_types(n1, n2)

      expect(left).to  eq('foo')
      expect(right).to eq('bar')
    end

    it 'returns two Strings when using two Attributes' do
      n1 = Oga::XML::Attribute.new(:value => 'foo')
      n2 = Oga::XML::Attribute.new(:value => 'bar')

      left, right = described_class.to_compatible_types(n1, n2)

      expect(left).to  eq('foo')
      expect(right).to eq('bar')
    end

    it 'returns two Strings when using a NodeSet and Float' do
      set = node_set(Oga::XML::Text.new(:text => 'foo'))

      left, right = described_class.to_compatible_types(set, 10.5)

      expect(left).to  eq('foo')
      expect(right).to eq('10.5')
    end

    it 'returns two Floats when using a Float and NodeSet' do
      set = node_set(Oga::XML::Text.new(:text => '20'))

      left, right = described_class.to_compatible_types(10.5, set)

      expect(left).to  eq(10.5)
      expect(right).to eq(20.0)
    end

    it 'returns two Strings when using a String and a Float' do
      left, right = described_class.to_compatible_types('foo', 10.5)

      expect(left).to  eq('foo')
      expect(right).to eq('10.5')
    end

    it 'returns two booleans when using a boolean and a non-zero Fixnum' do
      left, right = described_class.to_compatible_types(true, 10)

      expect(left).to  eq(true)
      expect(right).to eq(true)
    end

    it 'returns two booleans when using a boolean and 0' do
      left, right = described_class.to_compatible_types(true, 0)

      expect(left).to  eq(true)
      expect(right).to eq(false)
    end

    it 'returns two booleans when using a boolean and a negative Fixnum' do
      left, right = described_class.to_compatible_types(true, -5)

      expect(left).to  eq(true)
      expect(right).to eq(true)
    end

    it 'returns two booleans when using a boolean and a non-empty NodeSet' do
      set = node_set(Oga::XML::Text.new(:text => '20'))

      left, right = described_class.to_compatible_types(true, set)

      expect(left).to  eq(true)
      expect(right).to eq(true)
    end

    it 'returns two booleans when using a boolean and an empty NodeSet' do
      set = node_set

      left, right = described_class.to_compatible_types(true, set)

      expect(left).to  eq(true)
      expect(right).to eq(false)
    end
  end

  describe 'to_string' do
    describe 'using a Float' do
      it 'converts 10.0 to a String' do
        expect(described_class.to_string(10.0)).to eq('10')
      end

      it 'converts 10.5 to a String' do
        expect(described_class.to_string(10.5)).to eq('10.5')
      end
    end

    describe 'using a Node' do
      it 'converts an Element to a String' do
        node = Oga::XML::Element.new(:name => 'p')
        node.inner_text = 'foo'

        expect(described_class.to_string(node)).to eq('foo')
      end

      it 'converts a Text to a String' do
        node = Oga::XML::Text.new(:text => 'foo')

        expect(described_class.to_string(node)).to eq('foo')
      end
    end

    describe 'using a NodeSet' do
      it 'returns the text of the first node' do
        node1 = Oga::XML::Text.new(:text => 'foo')
        node2 = Oga::XML::Text.new(:text => 'bar')
        set   = node_set(node1, node2)

        expect(described_class.to_string(set)).to eq('foo')
      end

      it 'returns an empty String for an empty NodeSet' do
        expect(described_class.to_string(node_set)).to eq('')
      end
    end

    describe 'using a Fixnum' do
      it 'converts 10 to a String' do
        expect(described_class.to_string(10)).to eq('10')
      end
    end
  end

  describe 'to_float' do
    describe 'using a Float' do
      it 'returns the input Float' do
        expect(described_class.to_float(10.5)).to eq(10.5)
      end
    end

    describe 'using a String' do
      it 'returns a Float for a valid value' do
        expect(described_class.to_float('10.5')).to eq(10.5)
      end

      it 'returns Float::NAN for an invalid value' do
        expect(described_class.to_float('foo').nan?).to eq(true)
      end
    end

    describe 'using a NodeSet' do
      it 'returns a Float using the text of the first node' do
        set = node_set(Oga::XML::Text.new(:text => '10.5'))

        expect(described_class.to_float(set)).to eq(10.5)
      end
    end

    describe 'using an Node' do
      it 'returns a Float using the text of the node' do
        node = Oga::XML::Text.new(:text => '10.5')

        expect(described_class.to_float(node)).to eq(10.5)
      end
    end

    describe 'using a NilClass' do
      it 'returns Float::NAN' do
        expect(described_class.to_float(nil)).to be_nan
      end
    end

    describe 'using a TrueClass' do
      it 'returns 1.0' do
        expect(described_class.to_float(true)).to eq(1.0)
      end
    end

    describe 'using a FalseClass' do
      it 'returns 0.0' do
        expect(described_class.to_float(false)).to eq(0.0)
      end
    end
  end

  describe 'to_boolean' do
    it 'returns true for a non-empty String' do
      expect(described_class.to_boolean('foo')).to eq(true)
    end

    it 'returns false for an empty String' do
      expect(described_class.to_boolean('')).to eq(false)
    end

    it 'returns true for a positive Fixnum' do
      expect(described_class.to_boolean(10)).to eq(true)
    end

    it 'returns true for a positive Float' do
      expect(described_class.to_boolean(10.0)).to eq(true)
    end

    it 'returns true for a negative Fixnum' do
      expect(described_class.to_boolean(-10)).to eq(true)
    end

    it 'returns true for a negative Float' do
      expect(described_class.to_boolean(-10.0)).to eq(true)
    end

    it 'returns false for 0' do
      expect(described_class.to_boolean(0)).to eq(false)
    end

    it 'returns false for 0.0' do
      expect(described_class.to_boolean(0.0)).to eq(false)
    end

    it 'returns true for a non-empty NodeSet' do
      set = node_set(Oga::XML::Node.new)

      expect(described_class.to_boolean(set)).to eq(true)
    end

    it 'returns false for an empty NodeSet' do
      expect(described_class.to_boolean(node_set)).to eq(false)
    end

    it 'returns true for an Element' do
      element = Oga::XML::Element.new(:name => 'foo')

      expect(described_class.to_boolean(element)).to eq(true)
    end
  end
end
