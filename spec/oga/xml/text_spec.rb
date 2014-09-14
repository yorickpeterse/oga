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

  context '#to_html' do
    before do
      @instance = described_class.new
    end

    example 'to_xml should be aliased as to_html' do
      @instance.method(:to_xml).should == @instance.method(:to_html)
    end
  end

  context '#to_xml' do
    before do
      @instance = described_class.new(:text => 'foo')
    end

    example 'generate the corresponding XML' do
      @instance.to_xml.should == 'foo'
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
