require 'spec_helper'

describe Oga::XML::Generator do
  describe '#to_xml' do
    describe 'using an unsupported root type' do
      it 'raises TypeError' do
        -> { described_class.new(:foo).to_xml }.should raise_error(TypeError)
      end
    end

    describe 'using an Element as the root node' do
      it 'returns a String' do
        element = Oga::XML::Element.new(name: 'foo')
        element.set('attr', 'value')

        output = described_class.new(element).to_xml

        output.should == '<foo attr="value" />'
      end
    end

    describe 'using a Document as the root node' do
      it 'returns a String' do
        element = Oga::XML::Element.new(name: 'foo')
        doc = Oga::XML::Document.new(children: [element])
        output = described_class.new(doc).to_xml

        output.should == '<foo />'
      end
    end

    describe 'using Element nodes with siblings' do
      it 'returns a String' do
        root = Oga::XML::Element.new(
          name: 'root',
          children: [
            Oga::XML::Element.new(name: 'a'),
            Oga::XML::Element.new(
              name: 'b',
              children: [Oga::XML::Element.new(name: 'c')]
            )
          ]
        )

        output = described_class.new(root).to_xml

        output.should == '<root><a /><b><c /></b></root>'
      end
    end
  end
end
