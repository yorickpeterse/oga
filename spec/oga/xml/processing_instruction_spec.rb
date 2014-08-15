require 'spec_helper'

describe Oga::XML::ProcessingInstruction do
  context '#initialize' do
    example 'set the name of the node' do
      described_class.new(:name => 'foo').name.should == 'foo'
    end

    example 'set the text of the node' do
      described_class.new(:text => 'foo').text.should == 'foo'
    end
  end

  context '#to_xml' do
    example 'conver the node into XML' do
      node = described_class.new(:name => 'foo', :text => ' bar ')

      node.to_xml.should == '<?foo bar ?>'
    end
  end

  context '#inspect' do
    example 'return the inspect value of the node' do
      node = described_class.new(:name => 'foo', :text => ' bar ')

      node.inspect.should == 'ProcessingInstruction(name: "foo" text: " bar ")'
    end
  end
end
