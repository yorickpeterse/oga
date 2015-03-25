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

  describe '#==' do
    describe 'when comparing with an object that is not a Namespace' do
      ns = described_class.new(:name => 'a')

      ns.should_not == 10
    end

    describe 'when comparing two Namespace instances' do
      it 'returns true if both namespace names are equal' do
        ns1 = described_class.new(:name => 'a')
        ns2 = described_class.new(:name => 'a')

        ns1.should == ns2
      end

      it 'returns true if both namespace names and URIs are equal' do
        ns1 = described_class.new(:name => 'a', :uri => 'foo')
        ns2 = described_class.new(:name => 'a', :uri => 'foo')

        ns1.should == ns2
      end

      it 'returns false if two namespace names are not equal' do
        ns1 = described_class.new(:name => 'a')
        ns2 = described_class.new(:name => 'b')

        ns1.should_not == ns2
      end

      it 'retrns false if two namespace URIs are not equal' do
        ns1 = described_class.new(:name => 'a', :uri => 'foo')
        ns2 = described_class.new(:name => 'a', :uri => 'bar')

        ns1.should_not == ns2
      end
    end
  end
end
