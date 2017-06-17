require 'spec_helper'

describe Oga::XPath::Compiler do
  before do
    @document = parse(<<-EOF.strip.gsub(/^\s+|\n/m, ''))
<root foo="bar">
  <foo>
    <bar></bar>
    <baz>
      <baz></baz>
    </baz>
  </foo>
  <baz></baz>
</root>
    EOF

    @foo1 = @document.children[0].children[0]
    @bar1 = @foo1.children[0]
    @baz1 = @foo1.children[1]
    @baz2 = @baz1.children[0]
    @baz3 = @document.children[0].children[1]
  end

  describe 'relative to a document' do
    describe 'preceding::*' do
      it 'returns an empty NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set)
      end
    end

    describe 'root/foo/baz/preceding::bar' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@bar1))
      end
    end

    describe 'root/baz/preceding::baz' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@baz1, @baz2))
      end
    end
  end

  describe 'relative to an element' do
    describe 'preceding::root' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@foo1)).to eq(@document.children)
      end
    end

    describe 'preceding::baz' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@baz3)).to eq(node_set(@baz1, @baz2))
      end
    end
  end

  describe 'relative to the root element' do
    describe 'preceding::*' do
      it 'returns an empty NodeSet' do
        expect(evaluate_xpath(@document.children[0])).to eq(node_set)
      end
    end
  end

  describe 'relative to an attribute' do
    describe 'preceding::*' do
      it 'returns an empty NodeSet' do
        root = @document.children[0]

        expect(evaluate_xpath(root.attribute('foo'))).to eq(node_set)
      end
    end
  end
end
