require 'spec_helper'

describe Oga::XML::Parser do
  context 'empty elements' do
    before :all do
      @element = parse('<p></p>').children[0]
    end

    example 'return an Element instance' do
      @element.is_a?(Oga::XML::Element).should == true
    end

    example 'set the name of the element' do
      @element.name.should == 'p'
    end
  end

  context 'elements with namespaces' do
    before :all do
      @element = parse('<foo:p></p>').children[0]
    end

    example 'return an Element instance' do
      @element.is_a?(Oga::XML::Element).should == true
    end

    example 'set the name of the element' do
      @element.name.should == 'p'
    end

    example 'set the namespace of the element' do
      @element.namespace.should == 'foo'
    end
  end

  context 'elements with attributes' do
    before :all do
      @element = parse('<foo bar="baz"></foo>').children[0]
    end

    example 'return an Element instance' do
      @element.is_a?(Oga::XML::Element).should == true
    end

    example 'set the bar attribute' do
      @element.attribute('bar').should == 'baz'
    end
  end

  context 'elements with child elements' do
    before :all do
      @element = parse('<a><b></b></a>').children[0]
    end

    example 'set the name of the outer element' do
      @element.name.should == 'a'
    end

    example 'set the child elements' do
      @element.children[0].is_a?(Oga::XML::Element).should == true
    end

    example 'set the name of the child element' do
      @element.children[0].name.should == 'b'
    end
  end

  context 'elements with child elements and text' do
    before :all do
      @element = parse('<a>Foo<b>bar</b></a>').children[0]
    end

    example 'include the text node of the outer element' do
      @element.children[0].is_a?(Oga::XML::Text).should == true
    end

    example 'include the text node of the inner element' do
      @element.children[1].children[0].is_a?(Oga::XML::Text).should == true
    end
  end
end
