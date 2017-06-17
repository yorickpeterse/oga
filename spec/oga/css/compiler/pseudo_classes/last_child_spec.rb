require 'spec_helper'

describe 'CSS selector evaluation' do
  describe ':last-child pseudo class' do
    before do
      @document = parse('<root><a /><b /></root>')

      @a1 = @document.children[0].children[0]
      @b1 = @document.children[0].children[1]
    end

    it 'returns a node set containing the last child node' do
      expect(evaluate_css(@document, 'root :last-child')).to eq(node_set(@b1))
    end

    it 'returns a node set containing the last child node with a node test' do
      expect(evaluate_css(@document, 'root b:last-child')).to eq(node_set(@b1))
    end

    it 'returns an empty node set for non last-child nodes' do
      expect(evaluate_css(@document, 'root a:last-child')).to eq(node_set)
    end
  end
end
