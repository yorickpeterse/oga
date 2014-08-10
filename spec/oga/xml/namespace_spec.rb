require 'spec_helper'

describe Oga::XML::Namespace do
  context '#initialize' do
    example 'set the name' do
      described_class.new(:name => 'a').name.should == 'a'
    end
  end

  context '#to_s' do
    example 'convert the Namespace to a String' do
      described_class.new(:name => 'x').to_s.should == 'x'
    end
  end

  context '#inspect' do
    example 'return the inspect value' do
      ns = described_class.new(:name => 'x', :uri => 'y')

      ns.inspect.should == 'Namespace(name: "x" uri: "y")'
    end
  end
end
