require 'spec_helper'

describe 'CSS selector evaluation' do
  describe 'axes' do
    describe '> axis' do
      before do
        @document = parse('<root><a><a /></a></root>')

        @a1 = @document.children[0].children[0]
      end

      it 'returns a node set containing direct child nodes' do
        expect(evaluate_css(@document, 'root > a')).to eq(node_set(@a1))
      end

      it 'returns a node set containing direct child nodes relative to a node' do
        expect(evaluate_css(@a1, '> a')).to eq(@a1.children)
      end

      it 'returns an empty node set for non matching child nodes' do
        expect(evaluate_css(@document, '> a')).to eq(node_set)
      end
    end

    describe '+ axis' do
      before do
        @document = parse('<root><a /><b /><b /></root>')

        @b1 = @document.children[0].children[1]
        @b2 = @document.children[0].children[2]
      end

      it 'returns a node set containing following siblings' do
        expect(evaluate_css(@document, 'root a + b')).to eq(node_set(@b1))
      end

      it 'returns a node set containing following siblings relatie to a node' do
        expect(evaluate_css(@b1, '+ b')).to eq(node_set(@b2))
      end

      it 'returns an empty node set for non matching following siblings' do
        expect(evaluate_css(@document, 'root a + c')).to eq(node_set)
      end
    end

    describe '~ axis' do
      before do
        @document = parse('<root><a /><b /><b /></root>')

        @b1 = @document.children[0].children[1]
        @b2 = @document.children[0].children[2]
      end

      it 'returns a node set containing following siblings' do
        expect(evaluate_css(@document, 'root a ~ b')).to eq(node_set(@b1, @b2))
      end

      it 'returns a node set containing following siblings relative to a node' do
        expect(evaluate_css(@b1, '~ b')).to eq(node_set(@b2))
      end

      it 'returns an empty node set for non matching following siblings' do
        expect(evaluate_css(@document, 'root a ~ c')).to eq(node_set)
      end
    end
  end
end
