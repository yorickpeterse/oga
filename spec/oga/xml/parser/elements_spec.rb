require 'spec_helper'

describe Oga::XML::Parser do
  describe 'empty elements' do
    before :all do
      @element = parse('<p></p>').children[0]
    end

    it 'returns an Element instance' do
      @element.is_a?(Oga::XML::Element).should == true
    end

    it 'sets the name of the element' do
      @element.name.should == 'p'
    end

    it 'does not set a namespace' do
      @element.namespace.should be_nil
    end
  end

  describe 'elements with namespaces' do
    before :all do
      @element = parse('<foo:p xmlns:foo="bar"></foo:p>').children[0]
    end

    it 'returns an Element instance' do
      @element.is_a?(Oga::XML::Element).should == true
    end

    it 'sets the name of the element' do
      @element.name.should == 'p'
    end

    it 'sets the namespace of the element' do
      @element.namespace.name.should == 'foo'
    end
  end

  describe 'elements with default namespaces' do
    before :all do
      @document = parse('<foo xmlns="bar"><bar></bar></foo>')

      @foo = @document.children[0]
      @bar = @foo.children[0]
    end

    it 'sets the namespace name of the <foo> element' do
      @foo.namespace.name.should == 'xmlns'
    end

    it 'sets the namespace URI of the <foo> element' do
      @foo.namespace.uri.should == 'bar'
    end

    it 'sets the namespace name of the <bar> element' do
      @bar.namespace.name.should == 'xmlns'
    end

    it 'sets the namespace URI of the <bar> element' do
      @bar.namespace.uri.should == 'bar'
    end
  end

  describe 'elements with attributes' do
    before :all do
      @element = parse('<foo bar="baz"></foo>').children[0]
    end

    it 'returns an Element instance' do
      @element.is_a?(Oga::XML::Element).should == true
    end

    it 'sets the bar attribute' do
      @element.attribute('bar').value.should == 'baz'
    end

    it 'does not set the attribute namespace' do
      @element.attribute('bar').namespace.should be_nil
    end
  end

  describe 'elements with attributes without values' do
    before :all do
      @element = parse('<foo bar></foo>').children[0]
    end

    it 'returns an Element instance' do
      @element.is_a?(Oga::XML::Element).should == true
    end

    it 'sets the bar attribute' do
      @element.attribute('bar').value.should be_nil
    end
  end

  describe 'elements with attributes with empty values' do
    before :all do
      @element = parse('<foo bar=""></foo>').children[0]
    end

    it 'returns an Element instance' do
      @element.is_a?(Oga::XML::Element).should == true
    end

    it 'sets the bar attribute' do
      @element.attribute('bar').value.should == ''
    end
  end

  describe 'elements with namespaced attributes' do
    before :all do
      @element = parse('<foo xmlns:x="x" x:bar="baz"></foo>').children[0]
    end

    it 'returns an Element instance' do
      @element.is_a?(Oga::XML::Element).should == true
    end

    it 'includes the namespace of the attribute' do
      @element.attribute('x:bar').namespace.name.should == 'x'
    end

    it 'includes the name of the attribute' do
      @element.attribute('x:bar').name.should == 'bar'
    end

    it 'includes the value of the attribute' do
      @element.attribute('x:bar').value.should == 'baz'
    end
  end

  describe 'elements with child elements' do
    before :all do
      @element = parse('<a><b></b></a>').children[0]
    end

    it 'sets the name of the outer element' do
      @element.name.should == 'a'
    end

    it 'sets the child elements' do
      @element.children[0].is_a?(Oga::XML::Element).should == true
    end

    it 'sets the name of the child element' do
      @element.children[0].name.should == 'b'
    end
  end

  describe 'elements with child elements and text' do
    before :all do
      @element = parse('<a>Foo<b>bar</b></a>').children[0]
    end

    it 'includes the text node of the outer element' do
      @element.children[0].is_a?(Oga::XML::Text).should == true
    end

    it 'includes the text node of the inner element' do
      @element.children[1].children[0].is_a?(Oga::XML::Text).should == true
    end
  end

  describe 'elements with namespace registrations' do
    before :all do
      document = parse('<root xmlns:a="1"><foo xmlns:b="2"></foo></root>')

      @root = document.children[0]
      @foo  = @root.children[0]
    end

    it 'returns the namespaces of the <root> node' do
      @root.namespaces['a'].name.should == 'a'
      @root.namespaces['a'].uri.should  == '1'
    end

    it 'returns the namespaces of the <foo> node' do
      @foo.namespaces['b'].name.should == 'b'
      @foo.namespaces['b'].uri.should  == '2'
    end

    it 'returns the available namespaces of the <root> node' do
      @root.available_namespaces['a'].name.should == 'a'
    end

    it 'returns the available namespaces of the <foo> node' do
      @foo.available_namespaces['a'].name.should == 'a'
      @foo.available_namespaces['b'].name.should == 'b'
    end
  end
end
