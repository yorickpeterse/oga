require 'spec_helper'

describe Oga::XML::Text do
  describe 'setting attributes' do
    it 'sets the text via the constructor' do
      described_class.new(:text => 'foo').text.should == 'foo'
    end

    it 'sets the text via a setter' do
      instance = described_class.new
      instance.text = 'foo'

      instance.text.should == 'foo'
    end
  end

  describe '#to_xml' do
    it 'generates the corresponding XML' do
      node = described_class.new(:text => 'foo')

      node.to_xml.should == 'foo'
    end

    it 'encodes special characters as XML entities' do
      node = described_class.new(:text => '&<>')

      node.to_xml.should == '&amp;&lt;&gt;'
    end
  end

  describe '#inspect' do
    before do
      @instance = described_class.new(:text => 'foo')
    end

    it 'returns the inspect value' do
      @instance.inspect.should == 'Text("foo")'
    end
  end
end
