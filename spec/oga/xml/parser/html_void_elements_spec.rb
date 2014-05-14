require 'spec_helper'

describe Oga::XML::Parser do
  context 'void elements' do
    before :all do
      @node = parse('<link>', :html => true).children[0]
    end

    example 'return an Element instance' do
      @node.is_a?(Oga::XML::Element).should == true
    end

    example 'set the name of the element' do
      @node.name.should == 'link'
    end
  end

  context 'nested void elements' do
    before :all do
      @node = parse('<head><link></head>', :html => true).children[0]
    end

    example 'set the name of the outer element' do
      @node.name.should == 'head'
    end

    example 'set the name of the inner element' do
      @node.children[0].name.should == 'link'
    end
  end

  context 'void elements with attributes' do
    before :all do
      @node = parse('<link href="foo">', :html => true).children[0]
    end

    example 'set the name of the element' do
      @node.name.should == 'link'
    end

    example 'set the attributes' do
      @node.attributes.should == {:href => 'foo'}
    end
  end
end
