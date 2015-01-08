require 'spec_helper'

describe Oga::XML::Comment do
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
    before do
      @instance = described_class.new(:text => 'foo')
    end

    it 'generates the corresponding XML' do
      @instance.to_xml.should == '<!--foo-->'
    end
  end

  describe '#inspect' do
    before do
      @instance = described_class.new(:text => 'foo')
    end

    it 'returns the inspect value' do
      @instance.inspect.should == 'Comment("foo")'
    end
  end
end
