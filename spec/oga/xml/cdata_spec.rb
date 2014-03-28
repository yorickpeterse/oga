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
end
