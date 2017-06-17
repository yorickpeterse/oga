require 'spec_helper'

describe Oga::XPath::Compiler do
  before do
    @document = parse('<a foo="bar"><b><b><c class="x"></c></b></b></a>')

    @a1 = @document.children[0]
    @b1 = @a1.children[0]
    @b2 = @b1.children[0]
    @c1 = @b2.children[0]
  end

  describe 'relative to a document' do
    describe 'descendant-or-self::b' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@b1, @b2))
      end
    end

    describe 'descendant-or-self::c' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@c1))
      end
    end

    describe 'descendant-or-self::a/descendant-or-self::*' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@a1, @b1, @b2, @c1))
      end
    end

    describe 'descendant-or-self::c[@class="x"]' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@c1))
      end
    end

    describe 'a/descendant-or-self::b' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@b1, @b2))
      end
    end

    describe 'descendant-or-self::a' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@a1))
      end
    end

    describe 'a/b/b/c/descendant-or-self::c' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@c1))
      end
    end

    describe 'descendant-or-self::b[1]' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@b1))
      end
    end

    describe 'descendant-or-self::foobar' do
      it 'returns an empty NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set)
      end
    end

    describe '//b' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@b1, @b2))
      end
    end

    describe '//a//*' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@b1, @b2, @c1))
      end
    end

    describe '//a/b' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@b1))
      end
    end

    describe 'a/@foo/descendant-or-self::*' do
      it 'returns an empty NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set)
      end
    end
  end

  describe 'relative to an element' do
    describe 'descendant-or-self::b' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@b1)).to eq(node_set(@b1, @b2))
      end
    end

    describe 'descendant-or-self::c' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@c1)).to eq(node_set(@c1))
      end
    end

    describe '//b' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@c1)).to eq(node_set(@b1, @b2))
      end
    end
  end
end
