require 'spec_helper'

describe Oga::XML::XmlDeclaration do
  describe 'setting attributes' do
    it 'sets the version via the constructor' do
      described_class.new(:version => '1.0').version.should == '1.0'
    end

    it 'sets the version via a setter' do
      instance = described_class.new
      instance.version = '1.0'

      instance.version.should == '1.0'
    end
  end

  describe 'default attribute values' do
    before do
      @instance = described_class.new
    end

    it 'sets the default version' do
      @instance.version.should == '1.0'
    end

    it 'sets the default encoding' do
      @instance.encoding.should == 'UTF-8'
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
      @instance.to_xml
        .should == '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>'
    end
  end

  describe '#inspect' do
    before do
      @instance = described_class.new(:version => '1.0')
    end

    it 'pretty-prints the node' do
      @instance.inspect.should == <<-EOF.strip
XmlDeclaration(version: "1.0" encoding: "UTF-8")
      EOF
    end
  end
end
