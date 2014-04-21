require 'spec_helper'

describe Oga::XML::Parser do
  context 'elements with parents' do
    before :all do
      @parent = parse('<a><b></b></a>').children[0]
    end

    example 'return an Element instance for the parent' do
      @parent.children[0].parent.is_a?(Oga::XML::Element).should == true
    end

    example 'set the correct parent' do
      @parent.children[0].parent.should == @parent
    end
  end

  context 'text nodes with parents' do
    before :all do
      @parent = parse('<a>foo</a>').children[0]
    end

    example 'return an Element instance for the parent' do
      @parent.children[0].parent.is_a?(Oga::XML::Element).should == true
    end

    example 'set the correct parent' do
      @parent.children[0].parent.should == @parent
    end
  end

  context 'elements with adjacent elements' do
    before :all do
      @document = parse('<a></a><b></b>')
    end

    example 'return an Element instance for the next element' do
      @document.children[0].next.is_a?(Oga::XML::Element).should == true
    end

    example 'set the correct next element' do
      @document.children[0].next.should == @document.children[1]
    end

    example 'return an Element instance for the previous element' do
      @document.children[1].previous.is_a?(Oga::XML::Element).should == true
    end

    example 'set the correct previous element' do
      @document.children[1].previous.should == @document.children[0]
    end
  end
end
