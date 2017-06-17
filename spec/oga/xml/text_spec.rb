require 'spec_helper'

describe Oga::XML::Text do
  describe 'setting attributes' do
    it 'sets the text via the constructor' do
      expect(described_class.new(:text => 'foo').text).to eq('foo')
    end

    it 'sets the text via a setter' do
      instance = described_class.new
      instance.text = 'foo'

      expect(instance.text).to eq('foo')
    end
  end

  describe '#text' do
    describe 'with XML entities' do
      it 'converts &amp; to &' do
        expect(described_class.new(:text => '&amp;').text).to eq('&')
      end

      it 'converts &lt; to <' do
        expect(described_class.new(:text => '&lt;').text).to eq('<')
      end

      it 'converts &gt; to >' do
        expect(described_class.new(:text => '&gt;').text).to eq('>')
      end

      it 'caches the converted text' do
        node = described_class.new(:text => '&amp;')

        expect(Oga::XML::Entities).to receive(:decode).once.and_call_original

        expect(node.text).to eq('&')
        expect(node.text).to eq('&')
      end

      it 'converts new text set using text=' do
        node = described_class.new(:text => '&amp;')

        expect(node.text).to eq('&')

        node.text = '&lt;'

        expect(node.text).to eq('<')
      end
    end

    describe 'with HTML entities' do
      before do
        @document = Oga::XML::Document.new(:type => :html)
      end

      it 'converts &amp; to &' do
        node = described_class.new(:text => '&amp;')

        @document.children << node

        expect(node.text).to eq('&')
      end

      it 'converts &lt; to <' do
        node = described_class.new(:text => '&lt;')

        @document.children << node

        expect(node.text).to eq('<')
      end

      it 'converts &gt; to >' do
        node = described_class.new(:text => '&gt;')

        @document.children << node

        expect(node.text).to eq('>')
      end

      it 'converts &nbsp; into a space' do
        node = described_class.new(:text => '&nbsp;')

        @document.children << node

        expect(node.text).to eq([160].pack('U'))
      end
    end

    describe 'inside an HTML script element' do
      before do
        @element  = Oga::XML::Element.new(:name => 'script')
        @document = Oga::XML::Document.new(
          :type     => :html,
          :children => [@element]
        )
      end

      it 'does not decode any entities' do
        @element.inner_text = '&foo;'

        expect(@element.inner_text).to eq('&foo;')
      end
    end

    describe 'inside an HTML style element' do
      before do
        @element  = Oga::XML::Element.new(:name => 'style')
        @document = Oga::XML::Document.new(
          :type     => :html,
          :children => [@element]
        )
      end

      it 'does not decode any entities' do
        @element.inner_text = '&foo;'

        expect(@element.inner_text).to eq('&foo;')
      end
    end
  end

  describe '#to_xml' do
    it 'generates the corresponding XML' do
      node = described_class.new(:text => 'foo')

      expect(node.to_xml).to eq('foo')
    end

    it 'encodes special characters as XML entities' do
      node = described_class.new(:text => '&<>')

      expect(node.to_xml).to eq('&amp;&lt;&gt;')
    end

    describe 'inside an XML document' do
      it 'encodes special characters as XML entities' do
        document = Oga::XML::Document.new
        script   = Oga::XML::Element.new(:name => 'script')
        text     = described_class.new(:text => 'x > y')

        script.children   << text
        document.children << script

        expect(text.to_xml).to eq('x &gt; y')
      end
    end

    describe 'inside an HTML <script> element' do
      it 'does not encode special characters as XML entities' do
        document = Oga::XML::Document.new(:type => :html)
        script   = Oga::XML::Element.new(:name => 'script')
        text     = described_class.new(:text => 'x > y')

        script.children   << text
        document.children << script

        expect(text.to_xml).to eq('x > y')
      end
    end

    describe 'inside an HTML <style> element' do
      it 'does not encode special characters as XML entities' do
        document = Oga::XML::Document.new(:type => :html)
        style    = Oga::XML::Element.new(:name => 'style')
        text     = described_class.new(:text => 'x > y')

        style.children    << text
        document.children << style

        expect(text.to_xml).to eq('x > y')
      end
    end
  end

  describe '#inspect' do
    before do
      @instance = described_class.new(:text => 'foo')
    end

    it 'returns the inspect value' do
      expect(@instance.inspect).to eq('Text("foo")')
    end
  end
end
