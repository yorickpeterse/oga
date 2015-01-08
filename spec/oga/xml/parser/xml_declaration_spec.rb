require 'spec_helper'

describe Oga::XML::Parser do
  describe 'empty XML declaration tags' do
    before :all do
      @node = parse('<?xml?>').xml_declaration
    end

    it 'returns an XmlDeclaration instance' do
      @node.is_a?(Oga::XML::XmlDeclaration).should == true
    end

    it 'sets the default XML version' do
      @node.version.should == '1.0'
    end

    it 'sets the default encoding' do
      @node.encoding.should == 'UTF-8'
    end
  end

  describe 'XML declaration tags with custom attributes' do
    before :all do
      @node = parse('<?xml version="1.5" encoding="foo" ?>').xml_declaration
    end

    it 'returns an XmlDeclaration instance' do
      @node.is_a?(Oga::XML::XmlDeclaration).should == true
    end

    it 'sets the XML version' do
      @node.version.should == '1.5'
    end

    it 'sets the encoding' do
      @node.encoding.should == 'foo'
    end
  end
end
