require 'spec_helper'

describe Oga::XML::ToXML do
  describe '#to_s' do
    it 'is an alias of to_xml' do
      node = Oga::XML::Element.new(name: 'foo')

      expect(node.method(:to_s)).to eq(node.method(:to_xml))
    end
  end
end
