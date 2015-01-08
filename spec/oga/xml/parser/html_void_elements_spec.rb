require 'spec_helper'

describe Oga::XML::Parser do
  describe 'void elements' do
    before :all do
      @node = parse('<link>', :html => true).children[0]
    end

    it 'returns an Element instance' do
      @node.is_a?(Oga::XML::Element).should == true
    end

    it 'sets the name of the element' do
      @node.name.should == 'link'
    end
  end

  describe 'nested void elements' do
    before :all do
      @node = parse('<head><link></head>', :html => true).children[0]
    end

    it 'sets the name of the outer element' do
      @node.name.should == 'head'
    end

    it 'sets the name of the inner element' do
      @node.children[0].name.should == 'link'
    end
  end

  describe 'void elements with different casing' do
    before :all do
      @node_uc = parse_html('<BR>').children[0]
    end

    it 'parses void elements with different casing' do
      @node_uc.is_a?(Oga::XML::Element).should == true
    end

    it 'sets the name of the void element to match casing' do
      @node_uc.name.should == 'BR'
    end
  end

  describe 'void elements with attributes' do
    before :all do
      @node = parse('<link href="foo">', :html => true).children[0]
    end

    it 'sets the name of the element' do
      @node.name.should == 'link'
    end

    it 'sets the attributes' do
      @node.attribute('href').value.should == 'foo'
    end
  end
end
