require 'spec_helper'

describe Oga::XPath::Compiler do
  before do
    @document = parse(<<-EOF.strip.gsub(/^\s+|\n/m, ''))
<root foo="bar">
  <foo>
  </foo>
  <bar>
    <foo></foo>
    <baz></baz>
  </bar>
</root>
    EOF

    @foo1 = @document.children[0].children[0]
    @foo2 = @document.children[0].children[1].children[0]
    @bar1 = @document.children[0].children[1]
  end

  describe 'relative to a document' do
    describe 'preceding-sibling::*' do
      it 'returns an empty NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set)
      end
    end

    describe 'root/bar/preceding-sibling::foo' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@foo1))
      end
    end

    describe 'root/bar/baz/preceding-sibling::foo' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@foo2))
      end
    end
  end

  describe 'relative to an element' do
    describe 'preceding-sibling::foo' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@bar1)).to eq(node_set(@foo1))
      end
    end
  end

  describe 'relative to the root element' do
    describe 'preceding-sibling::*' do
      it 'returns an empty NodeSet' do
        expect(evaluate_xpath(@document.children[0])).to eq(node_set)
      end
    end
  end

  describe 'relative to an attribute' do
    describe 'preceding-sibling::*' do
      it 'returns an empty NodeSet' do
        root = @document.children[0]

        expect(evaluate_xpath(root.attribute('foo'))).to eq(node_set)
      end
    end
  end
end
