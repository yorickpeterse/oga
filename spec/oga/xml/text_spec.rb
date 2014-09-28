require 'spec_helper'

describe Oga::XML::Text do
  context 'setting attributes' do
    example 'set the text via the constructor' do
      described_class.new(:text => 'foo').text.should == 'foo'
    end

    example 'set the text via a setter' do
      instance = described_class.new
      instance.text = 'foo'

      instance.text.should == 'foo'
    end
  end

  context '#to_xml' do
    example 'generate the corresponding XML' do
      node = described_class.new(:text => 'foo')

      node.to_xml.should == 'foo'
    end

    example 'encode special characters as XML entities' do
      node = described_class.new(:text => '&<>')

      node.to_xml.should == '&amp;&lt;&gt;'
    end
  end

  context '#inspect' do
    before do
      @instance = described_class.new(:text => 'foo')
    end

    example 'return the inspect value' do
      @instance.inspect.should == 'Text("foo")'
    end
  end
end
