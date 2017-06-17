require 'spec_helper'

describe Oga::XML::Namespace do
  describe '#initialize' do
    it 'sets the name' do
      expect(described_class.new(:name => 'a').name).to eq('a')
    end
  end

  describe '#to_s' do
    it 'converts the Namespace to a String' do
      expect(described_class.new(:name => 'x').to_s).to eq('x')
    end
  end

  describe '#inspect' do
    it 'returns the inspect value' do
      ns = described_class.new(:name => 'x', :uri => 'y')

      expect(ns.inspect).to eq('Namespace(name: "x" uri: "y")')
    end
  end

  describe '#==' do
    describe 'when comparing with an object that is not a Namespace' do
      it 'returns false' do
        ns = described_class.new(:name => 'a')

        expect(ns).not_to eq(10)
      end
    end

    describe 'when comparing two Namespace instances' do
      it 'returns true if both namespace names are equal' do
        ns1 = described_class.new(:name => 'a')
        ns2 = described_class.new(:name => 'a')

        expect(ns1).to eq(ns2)
      end

      it 'returns true if both namespace names and URIs are equal' do
        ns1 = described_class.new(:name => 'a', :uri => 'foo')
        ns2 = described_class.new(:name => 'a', :uri => 'foo')

        expect(ns1).to eq(ns2)
      end

      it 'returns false if two namespace names are not equal' do
        ns1 = described_class.new(:name => 'a')
        ns2 = described_class.new(:name => 'b')

        expect(ns1).not_to eq(ns2)
      end

      it 'retrns false if two namespace URIs are not equal' do
        ns1 = described_class.new(:name => 'a', :uri => 'foo')
        ns2 = described_class.new(:name => 'a', :uri => 'bar')

        expect(ns1).not_to eq(ns2)
      end
    end
  end
end
