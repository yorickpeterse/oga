require 'spec_helper'

describe Oga::XML::XmlDeclaration do
  describe 'setting attributes' do
    it 'sets the version via the constructor' do
      expect(described_class.new(:version => '1.0').version).to eq('1.0')
    end

    it 'sets the version via a setter' do
      instance = described_class.new
      instance.version = '1.0'

      expect(instance.version).to eq('1.0')
    end
  end

  describe 'default attribute values' do
    before do
      @instance = described_class.new
    end

    it 'sets the default version' do
      expect(@instance.version).to eq('1.0')
    end

    it 'sets the default encoding' do
      expect(@instance.encoding).to eq('UTF-8')
    end
  end

  describe '#name' do
    it 'returns the name of the node' do
      expect(described_class.new.name).to eq('xml')
    end
  end

  describe '#to_xml' do
    before do
      @instance = described_class.new(
        :version    => '1.0',
        :encoding   => 'UTF-8',
        :standalone => 'yes'
      )
    end

    it 'generates the corresponding XML' do
      expect(@instance.to_xml)
        .to eq('<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>')
    end
  end

  describe '#inspect' do
    before do
      @instance = described_class.new(:version => '1.0')
    end

    it 'pretty-prints the node' do
      expect(@instance.inspect).to eq <<-EOF.strip
XmlDeclaration(version: "1.0" encoding: "UTF-8")
      EOF
    end
  end
end
