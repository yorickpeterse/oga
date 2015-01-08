require 'spec_helper'

describe Oga::XML::ProcessingInstruction do
  describe '#initialize' do
    it 'sets the name of the node' do
      described_class.new(:name => 'foo').name.should == 'foo'
    end

    it 'sets the text of the node' do
      described_class.new(:text => 'foo').text.should == 'foo'
    end
  end

  describe '#to_xml' do
    it 'convers the node into XML' do
      node = described_class.new(:name => 'foo', :text => ' bar ')

      node.to_xml.should == '<?foo bar ?>'
    end
  end

  describe '#inspect' do
    it 'returns the inspect value of the node' do
      node = described_class.new(:name => 'foo', :text => ' bar ')

      node.inspect.should == 'ProcessingInstruction(name: "foo" text: " bar ")'
    end
  end
end
