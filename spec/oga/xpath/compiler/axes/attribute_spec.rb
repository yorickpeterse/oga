require 'spec_helper'

describe Oga::XPath::Compiler do
  before do
    @document = parse('<a foo="bar"></a>')

    @a1   = @document.children[0]
    @attr = @a1.attribute('foo')
  end

  describe 'relative to a document' do
    describe 'attribute::foo' do
      it 'returns an empty NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set)
      end
    end
  end

  describe 'relative to an element' do
    describe 'attribute::foo' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@a1)).to eq(node_set(@attr))
      end
    end

    describe '@foo' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@a1)).to eq(node_set(@attr))
      end
    end

    describe 'attribute::bar' do
      it 'returns an empty NodeSet' do
        expect(evaluate_xpath(@a1)).to eq(node_set)
      end
    end

    describe 'attribute::foo/bar' do
      it 'returns an empty NodeSet' do
        expect(evaluate_xpath(@a1)).to eq(node_set)
      end
    end
  end
end
