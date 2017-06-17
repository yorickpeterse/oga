require 'spec_helper'

describe Oga::XPath::Compiler do
  before do
    @document = parse('<a foo="bar"><b><c></c></b></a>')

    @a1 = @document.children[0]
    @b1 = @a1.children[0]
    @c1 = @b1.children[0]
  end

  describe 'relative to a document' do
    describe 'ancestor-or-self::a' do
      it 'returns an empty NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set)
      end
    end
  end

  describe 'relative to an attribute' do
    describe 'ancestor-or-self::a' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@a1.attribute('foo'))).to eq(node_set(@a1))
      end
    end

    describe 'ancestor-or-self::foo' do
      it 'returns an empty NodeSet' do
        expect(evaluate_xpath(@a1.attribute('foo'))).to eq(node_set)
      end
    end
  end

  describe 'relative to an element' do
    describe 'ancestor-or-self::a' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@c1)).to eq(node_set(@a1))
      end
    end

    describe 'ancestor-or-self::b' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@c1)).to eq(node_set(@b1))
      end
    end

    describe 'ancestor-or-self::c' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@c1)).to eq(node_set(@c1))
      end
    end

    describe 'ancestor-or-self::*[1]' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@c1)).to eq(node_set(@c1))
      end
    end

    describe 'ancestor-or-self::*' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@c1)).to eq(node_set(@c1, @b1, @a1))
      end
    end

    describe 'ancestor-or-self::foo' do
      it 'returns an empty NodeSet' do
        expect(evaluate_xpath(@c1)).to eq(node_set)
      end
    end

    describe 'ancestor-or-self::*/ancestor-or-self::a' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@c1)).to eq(node_set(@a1))
      end
    end
  end
end
