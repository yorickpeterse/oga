require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'not() function' do
    before do
      @document = parse('<root>foo</root>')

      @root = @document.children[0]
    end

    describe 'at the top-level' do
      it 'returns false when the argument is a non-zero integer' do
        expect(evaluate_xpath(@document, 'not(10)')).to eq(false)
      end

      it 'returns true when the argument is a zero integer' do
        expect(evaluate_xpath(@document, 'not(0)')).to eq(true)
      end

      it 'returns false when the argument is a non-empty node set' do
        expect(evaluate_xpath(@document, 'not(root)')).to eq(false)
      end

      it 'returns itrue when the argument is an empty node set' do
        expect(evaluate_xpath(@document, 'not(foo)')).to eq(true)
      end
    end

    describe 'in a predicate' do
      it 'returns a NodeSet containing all matching nodes ' do
        expect(evaluate_xpath(@document, 'root[not(comment())]'))
          .to eq(node_set(@root))
      end
    end
  end
end
