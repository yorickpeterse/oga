require 'spec_helper'

describe Oga::XML::Namespace do
  describe '#initialize' do
    it 'sets the name' do
      described_class.new(:name => 'a').name.should == 'a'
    end
  end

  describe '#to_s' do
    it 'converts the Namespace to a String' do
      described_class.new(:name => 'x').to_s.should == 'x'
    end
  end

  describe '#inspect' do
    it 'returns the inspect value' do
      ns = described_class.new(:name => 'x', :uri => 'y')

      ns.inspect.should == 'Namespace(name: "x" uri: "y")'
    end
  end
end
