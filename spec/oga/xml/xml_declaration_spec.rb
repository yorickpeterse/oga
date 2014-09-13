require 'spec_helper'

describe Oga::XML::XmlDeclaration do
  context 'setting attributes' do
    example 'set the version via the constructor' do
      described_class.new(:version => '1.0').version.should == '1.0'
    end

    example 'set the version via a setter' do
      instance = described_class.new
      instance.version = '1.0'

      instance.version.should == '1.0'
    end
  end

  context 'default attribute values' do
    before do
      @instance = described_class.new
    end

    example 'set the default version' do
      @instance.version.should == '1.0'
    end

    example 'set the default encoding' do
      @instance.encoding.should == 'UTF-8'
    end
  end

  context '#to_xml' do
    before do
      @instance = described_class.new(
        :version    => '1.0',
        :encoding   => 'UTF-8',
        :standalone => 'yes'
      )
    end

    example 'generate the corresponding XML' do
      @instance.to_xml
        .should == '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>'
    end
  end

  context '#inspect' do
    before do
      @instance = described_class.new(:version => '1.0')
    end

    example 'pretty-print the node' do
      @instance.inspect.should == <<-EOF.strip
XmlDeclaration(version: "1.0" encoding: "UTF-8")
      EOF
    end
  end
end
