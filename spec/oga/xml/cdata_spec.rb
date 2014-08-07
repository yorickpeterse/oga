require 'spec_helper'

describe Oga::XML::Cdata do
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
    before do
      @instance = described_class.new(:text => 'foo')
    end

    example 'generate the corresponding XML' do
      @instance.to_xml.should == '<![CDATA[foo]]>'
    end
  end

  context '#inspect' do
    before do
      @instance = described_class.new(:text => 'foo')
    end

    example 'return the inspect value' do
      @instance.inspect.should == 'Cdata("foo")'
    end
  end

  context '#type' do
    example 'return the type of the node' do
      described_class.new.node_type.should == :cdata
    end
  end
end
