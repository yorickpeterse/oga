require 'spec_helper'

describe Oga::XPath::Compiler do
  before do
    # Strip whitespace so it's easier to retrieve/compare elements.
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

    @bar1 = @document.children[0].children[0].children[0]
    @baz1 = @document.children[0].children[0].children[1]
    @baz2 = @baz1.children[0]
    @baz3 = @document.children[0].children[1]
  end

  describe 'relative to a document' do
    describe 'following-sibling::foo' do
      # This should return an empty set since the document doesn't have any
      # following nodes.
      it 'returns an empty NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set)
      end
    end

    describe 'root/foo/following-sibling::baz' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@baz3))
      end
    end

    describe 'root/foo/bar/following-sibling::baz' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@baz1))
      end
    end
  end

  describe 'relative to an element' do
    describe 'following-sibling::baz' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@bar1)).to eq(node_set(@baz1))
      end
    end
  end

  describe 'relative to an attribute' do
    describe 'following-sibling::foo' do
      it 'returns an empty NodeSet' do
        root = @document.children[0]

        expect(evaluate_xpath(root.attribute('foo'))).to eq(node_set)
      end
    end
  end
end
