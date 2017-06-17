require 'spec_helper'

describe Oga::XPath::Compiler do
  before do
    @document = parse('<a foo="bar"><b></b></a>')

    @a1 = @document.children[0]
    @b1 = @a1.children[0]
  end

  describe 'relative to a document' do
    describe 'parent::a' do
      it 'returns an empty NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set)
      end
    end

    describe 'a/b/parent::a' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@a1))
      end
    end

    describe 'a/b/..' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@a1))
      end
    end
  end

  describe 'relative to an element' do
    describe 'parent::a' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@b1)).to eq(node_set(@a1))
      end
    end
  end

  describe 'relative to the root element' do
    describe 'parent::*' do
      it 'returns an empty NodeSet' do
        expect(evaluate_xpath(@a1)).to eq(node_set)
      end
    end
  end

  describe 'relative to an attribute' do
    describe 'parent::a' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@a1.attribute('foo'))).to eq(node_set(@a1))
      end
    end
  end
end
