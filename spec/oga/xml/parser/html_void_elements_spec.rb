require 'spec_helper'

describe Oga::XML::Parser do
  describe 'void elements' do
    before :all do
      @node = parse('<link>', :html => true).children[0]
    end

    it 'returns an Element instance' do
      expect(@node.is_a?(Oga::XML::Element)).to eq(true)
    end

    it 'sets the name of the element' do
      expect(@node.name).to eq('link')
    end
  end

  describe 'nested void elements' do
    before :all do
      @node = parse('<head><link></head>', :html => true).children[0]
    end

    it 'sets the name of the outer element' do
      expect(@node.name).to eq('head')
    end

    it 'sets the name of the inner element' do
      expect(@node.children[0].name).to eq('link')
    end
  end

  describe 'void elements with different casing' do
    before :all do
      @node_uc = parse_html('<BR>').children[0]
    end

    it 'parses void elements with different casing' do
      expect(@node_uc.is_a?(Oga::XML::Element)).to eq(true)
    end

    it 'sets the name of the void element to match casing' do
      expect(@node_uc.name).to eq('BR')
    end
  end

  describe 'void elements with attributes' do
    before :all do
      @node = parse('<link href="foo">', :html => true).children[0]
    end

    it 'sets the name of the element' do
      expect(@node.name).to eq('link')
    end

    it 'sets the attributes' do
      expect(@node.attribute('href').value).to eq('foo')
    end
  end
end
