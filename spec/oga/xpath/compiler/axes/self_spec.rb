require 'spec_helper'

describe Oga::XPath::Compiler do
  before do
    @document = parse('<a foo="bar"><b>foo</b><b>bar<c>test</c></b></a>')

    @a1 = @document.children[0]
    @b1 = @a1.children[0]
    @b2 = @a1.children[1]
  end

  describe 'relative to a document' do
    describe 'a/self::a' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@a1))
      end
    end

    describe 'a/self::b' do
      it 'returns an empty NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set)
      end
    end

    describe 'a/.' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@a1))
      end
    end

    describe 'a/b[. = "foo"]' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@b1))
      end
    end

    describe 'a/b[c/. = "test"]' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@b2))
      end
    end

    describe 'a/b[c[. = "test"]]' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@b2))
      end
    end

    describe 'self::node()' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@document))
      end
    end
  end

  describe 'relative to an element' do
    describe 'self::node()' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@a1)).to eq(node_set(@a1))
      end
    end
  end

  describe 'relative to an attribute' do
    describe 'self::node()' do
      it 'returns a NodeSet' do
        attr = @a1.attribute('foo')

        expect(evaluate_xpath(attr)).to eq(node_set(attr))
      end
    end
  end
end
