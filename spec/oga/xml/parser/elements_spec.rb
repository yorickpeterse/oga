require 'spec_helper'

describe Oga::XML::Parser do
  describe 'empty elements' do
    before :all do
      @element = parse('<p></p>').children[0]
    end

    it 'returns an Element instance' do
      expect(@element.is_a?(Oga::XML::Element)).to eq(true)
    end

    it 'sets the name of the element' do
      expect(@element.name).to eq('p')
    end

    it 'does not set a namespace' do
      expect(@element.namespace).to be_nil
    end
  end

  describe 'elements with namespaces' do
    before :all do
      @element = parse('<foo:p xmlns:foo="bar"></foo:p>').children[0]
    end

    it 'returns an Element instance' do
      expect(@element.is_a?(Oga::XML::Element)).to eq(true)
    end

    it 'sets the name of the element' do
      expect(@element.name).to eq('p')
    end

    it 'sets the namespace of the element' do
      expect(@element.namespace.name).to eq('foo')
    end
  end

  describe 'elements with default namespaces' do
    before :all do
      @document = parse('<foo xmlns="bar"><bar></bar></foo>')

      @foo = @document.children[0]
      @bar = @foo.children[0]
    end

    it 'sets the namespace name of the <foo> element' do
      expect(@foo.namespace.name).to eq('xmlns')
    end

    it 'sets the namespace URI of the <foo> element' do
      expect(@foo.namespace.uri).to eq('bar')
    end

    it 'sets the namespace name of the <bar> element' do
      expect(@bar.namespace.name).to eq('xmlns')
    end

    it 'sets the namespace URI of the <bar> element' do
      expect(@bar.namespace.uri).to eq('bar')
    end
  end

  describe 'elements with attributes' do
    before :all do
      @element = parse('<foo bar="baz"></foo>').children[0]
    end

    it 'returns an Element instance' do
      expect(@element.is_a?(Oga::XML::Element)).to eq(true)
    end

    it 'sets the bar attribute' do
      expect(@element.attribute('bar').value).to eq('baz')
    end

    it 'does not set the attribute namespace' do
      expect(@element.attribute('bar').namespace).to be_nil
    end
  end

  describe 'elements with attributes without values' do
    before :all do
      @element = parse('<foo bar></foo>').children[0]
    end

    it 'returns an Element instance' do
      expect(@element.is_a?(Oga::XML::Element)).to eq(true)
    end

    it 'sets the bar attribute' do
      expect(@element.attribute('bar').value).to be_nil
    end
  end

  describe 'elements with attributes with empty values' do
    before :all do
      @element = parse('<foo bar=""></foo>').children[0]
    end

    it 'returns an Element instance' do
      expect(@element.is_a?(Oga::XML::Element)).to eq(true)
    end

    it 'sets the bar attribute' do
      expect(@element.attribute('bar').value).to eq('')
    end
  end

  describe 'elements with namespaced attributes' do
    before :all do
      @element = parse('<foo xmlns:x="x" x:bar="baz"></foo>').children[0]
    end

    it 'returns an Element instance' do
      expect(@element.is_a?(Oga::XML::Element)).to eq(true)
    end

    it 'includes the namespace of the attribute' do
      expect(@element.attribute('x:bar').namespace.name).to eq('x')
    end

    it 'includes the name of the attribute' do
      expect(@element.attribute('x:bar').name).to eq('bar')
    end

    it 'includes the value of the attribute' do
      expect(@element.attribute('x:bar').value).to eq('baz')
    end
  end

  describe 'elements with child elements' do
    before :all do
      @element = parse('<a><b></b></a>').children[0]
    end

    it 'sets the name of the outer element' do
      expect(@element.name).to eq('a')
    end

    it 'sets the child elements' do
      expect(@element.children[0].is_a?(Oga::XML::Element)).to eq(true)
    end

    it 'sets the name of the child element' do
      expect(@element.children[0].name).to eq('b')
    end
  end

  describe 'elements with child elements and text' do
    before :all do
      @element = parse('<a>Foo<b>bar</b></a>').children[0]
    end

    it 'includes the text node of the outer element' do
      expect(@element.children[0].is_a?(Oga::XML::Text)).to eq(true)
    end

    it 'includes the text node of the inner element' do
      expect(@element.children[1].children[0].is_a?(Oga::XML::Text)).to eq(true)
    end
  end

  describe 'elements with namespace registrations' do
    before :all do
      document = parse('<root xmlns:a="1"><foo xmlns:b="2"></foo></root>')

      @root = document.children[0]
      @foo  = @root.children[0]
    end

    it 'returns the namespaces of the <root> node' do
      expect(@root.namespaces['a'].name).to eq('a')
      expect(@root.namespaces['a'].uri).to  eq('1')
    end

    it 'returns the namespaces of the <foo> node' do
      expect(@foo.namespaces['b'].name).to eq('b')
      expect(@foo.namespaces['b'].uri).to  eq('2')
    end

    it 'returns the available namespaces of the <root> node' do
      expect(@root.available_namespaces['a'].name).to eq('a')
    end

    it 'returns the available namespaces of the <foo> node' do
      expect(@foo.available_namespaces['a'].name).to eq('a')
      expect(@foo.available_namespaces['b'].name).to eq('b')
    end
  end
end
