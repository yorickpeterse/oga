require 'spec_helper'

describe Oga::XML::Cdata do
  describe 'setting attributes' do
    it 'sets the text via the constructor' do
      expect(described_class.new(:text => 'foo').text).to eq('foo')
    end

    it 'sets the text via a setter' do
      instance = described_class.new
      instance.text = 'foo'

      expect(instance.text).to eq('foo')
    end
  end

  describe '#to_xml' do
    before do
      @instance = described_class.new(:text => 'foo')
    end

    it 'generates the corresponding XML' do
      expect(@instance.to_xml).to eq('<![CDATA[foo]]>')
    end
  end

  describe '#inspect' do
    before do
      @instance = described_class.new(:text => 'foo')
    end

    it 'returns the inspect value' do
      expect(@instance.inspect).to eq('Cdata("foo")')
    end
  end
end
