require 'spec_helper'

describe Oga::XML::Parser do
  context 'empty cdata tags' do
    before :all do
      @node = parse('<![CDATA[]]>').children[0]
    end

    example 'return a Cdata instance' do
      @node.is_a?(Oga::XML::Cdata).should == true
    end
  end

  context 'cdata tags with text' do
    before :all do
      @node = parse('<![CDATA[foo]]>').children[0]
    end

    example 'return a Cdata instance' do
      @node.is_a?(Oga::XML::Cdata).should == true
    end

    example 'set the text of the tag' do
      @node.text.should == 'foo'
    end
  end

  context 'cdata tags with nested elements' do
    before :all do
      @node = parse('<![CDATA[<p>foo</p>]]>').children[0]
    end

    example 'set the HTML as raw text' do
      @node.text.should == '<p>foo</p>'
    end
  end
end
