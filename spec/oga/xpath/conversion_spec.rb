require 'spec_helper'

describe Oga::XPath::Conversion do
  describe 'to_compatible_types' do
    it 'returns two Strings when using two NodeSets' do
      set1 = node_set(Oga::XML::Text.new(:text => 'foo'))
      set2 = node_set(Oga::XML::Text.new(:text => 'bar'))

      left, right = described_class.to_compatible_types(set1, set2)

      left.should  == 'foo'
      right.should == 'bar'
    end

    it 'returns two Strings when using two Nodes' do
      n1 = Oga::XML::Text.new(:text => 'foo')
      n2 = Oga::XML::Text.new(:text => 'bar')

      left, right = described_class.to_compatible_types(n1, n2)

      left.should  == 'foo'
      right.should == 'bar'
    end

    it 'returns two Strings when using two Attributes' do
      n1 = Oga::XML::Attribute.new(:value => 'foo')
      n2 = Oga::XML::Attribute.new(:value => 'bar')

      left, right = described_class.to_compatible_types(n1, n2)

      left.should  == 'foo'
      right.should == 'bar'
    end

    it 'returns two Strings when using a NodeSet and Float' do
      set = node_set(Oga::XML::Text.new(:text => 'foo'))

      left, right = described_class.to_compatible_types(set, 10.5)

      left.should  == 'foo'
      right.should == '10.5'
    end

    it 'returns two Floats when using a Float and NodeSet' do
      set = node_set(Oga::XML::Text.new(:text => '20'))

      left, right = described_class.to_compatible_types(10.5, set)

      left.should  == 10.5
      right.should == 20.0
    end

    it 'returns two Strings when using a String and a Float' do
      left, right = described_class.to_compatible_types('foo', 10.5)

      left.should  == 'foo'
      right.should == '10.5'
    end

    it 'returns two booleans when using a boolean and a non-zero Fixnum' do
      left, right = described_class.to_compatible_types(true, 10)

      left.should  == true
      right.should == true
    end

    it 'returns two booleans when using a boolean and 0' do
      left, right = described_class.to_compatible_types(true, 0)

      left.should  == true
      right.should == false
    end

    it 'returns two booleans when using a boolean and a negative Fixnum' do
      left, right = described_class.to_compatible_types(true, -5)

      left.should  == true
      right.should == true
    end

    it 'returns two booleans when using a boolean and a non-empty NodeSet' do
      set = node_set(Oga::XML::Text.new(:text => '20'))

      left, right = described_class.to_compatible_types(true, set)

      left.should  == true
      right.should == true
    end

    it 'returns two booleans when using a boolean and an empty NodeSet' do
      set = node_set

      left, right = described_class.to_compatible_types(true, set)

      left.should  == true
      right.should == false
    end
  end

  describe 'to_string' do
    describe 'using a Float' do
      it 'converts 10.0 to a String' do
        described_class.to_string(10.0).should == '10'
      end

      it 'converts 10.5 to a String' do
        described_class.to_string(10.5).should == '10.5'
      end
    end

    describe 'using a Node' do
      it 'converts an Element to a String' do
        node = Oga::XML::Element.new(:name => 'p')
        node.inner_text = 'foo'

        described_class.to_string(node).should == 'foo'
      end

      it 'converts a Text to a String' do
        node = Oga::XML::Text.new(:text => 'foo')

        described_class.to_string(node).should == 'foo'
      end
    end

    describe 'using a NodeSet' do
      it 'returns the text of the first node' do
        node1 = Oga::XML::Text.new(:text => 'foo')
        node2 = Oga::XML::Text.new(:text => 'bar')
        set   = node_set(node1, node2)

        described_class.to_string(set).should == 'foo'
      end

      it 'returns an empty String for an empty NodeSet' do
        described_class.to_string(node_set).should == ''
      end
    end

    describe 'using a Fixnum' do
      it 'converts 10 to a String' do
        described_class.to_string(10).should == '10'
      end
    end
  end

  describe 'to_float' do
    describe 'using a Float' do
      it 'returns the input Float' do
        described_class.to_float(10.5).should == 10.5
      end
    end

    describe 'using a String' do
      it 'returns a Float for a valid value' do
        described_class.to_float('10.5').should == 10.5
      end

      it 'returns Float::NAN for an invalid value' do
        described_class.to_float('foo').nan?.should == true
      end
    end

    describe 'using a NodeSet' do
      it 'returns a Float using the text of the first node' do
        set = node_set(Oga::XML::Text.new(:text => '10.5'))

        described_class.to_float(set).should == 10.5
      end
    end

    describe 'using an Node' do
      it 'returns a Float using the text of the node' do
        node = Oga::XML::Text.new(:text => '10.5')

        described_class.to_float(node).should == 10.5
      end
    end

    describe 'using a NilClass' do
      it 'returns Float::NAN' do
        described_class.to_float(nil).should be_nan
      end
    end

    describe 'using a TrueClass' do
      it 'returns 1.0' do
        described_class.to_float(true).should == 1.0
      end
    end

    describe 'using a FalseClass' do
      it 'returns 0.0' do
        described_class.to_float(false).should == 0.0
      end
    end
  end

  describe 'to_boolean' do
    it 'returns true for a non-empty String' do
      described_class.to_boolean('foo').should == true
    end

    it 'returns false for an empty String' do
      described_class.to_boolean('').should == false
    end

    it 'returns true for a positive Fixnum' do
      described_class.to_boolean(10).should == true
    end

    it 'returns true for a positive Float' do
      described_class.to_boolean(10.0).should == true
    end

    it 'returns true for a negative Fixnum' do
      described_class.to_boolean(-10).should == true
    end

    it 'returns true for a negative Float' do
      described_class.to_boolean(-10.0).should == true
    end

    it 'returns false for 0' do
      described_class.to_boolean(0).should == false
    end

    it 'returns false for 0.0' do
      described_class.to_boolean(0.0).should == false
    end

    it 'returns true for a non-empty NodeSet' do
      set = node_set(Oga::XML::Node.new)

      described_class.to_boolean(set).should == true
    end

    it 'returns false for an empty NodeSet' do
      described_class.to_boolean(node_set).should == false
    end

    it 'returns true for an Element' do
      element = Oga::XML::Element.new(:name => 'foo')

      described_class.to_boolean(element).should == true
    end
  end
end
