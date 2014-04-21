require 'spec_helper'

describe Oga::XML::Parser do
  context 'empty XML declaration tags' do
    before :all do
      @node = parse('<?xml?>').xml_declaration
    end

    example 'return an XmlDeclaration instance' do
      @node.is_a?(Oga::XML::XmlDeclaration).should == true
    end

    example 'set the default XML version' do
      @node.version.should == '1.0'
    end

    example 'set the default encoding' do
      @node.encoding.should == 'UTF-8'
    end
  end

  context 'XML declaration tags with custom attributes' do
    before :all do
      @node = parse('<?xml version="1.5" encoding="foo" ?>').xml_declaration
    end

    example 'return an XmlDeclaration instance' do
      @node.is_a?(Oga::XML::XmlDeclaration).should == true
    end

    example 'set the XML version' do
      @node.version.should == '1.5'
    end

    example 'set the encoding' do
      @node.encoding.should == 'foo'
    end
  end
end
