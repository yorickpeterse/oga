require 'spec_helper'

describe Oga::XML::Parser do
  describe 'empty cdata tags' do
    before :all do
      @node = parse('<![CDATA[]]>').children[0]
    end

    it 'returns a Cdata instance' do
      expect(@node.is_a?(Oga::XML::Cdata)).to eq(true)
    end
  end

  describe 'cdata tags with text' do
    before :all do
      @node = parse('<![CDATA[foo]]>').children[0]
    end

    it 'returns a Cdata instance' do
      expect(@node.is_a?(Oga::XML::Cdata)).to eq(true)
    end

    it 'sets the text of the tag' do
      expect(@node.text).to eq('foo')
    end
  end

  describe 'cdata tags with nested elements' do
    before :all do
      @node = parse('<![CDATA[<p>foo</p>]]>').children[0]
    end

    it 'sets the HTML as raw text' do
      expect(@node.text).to eq('<p>foo</p>')
    end
  end
end
