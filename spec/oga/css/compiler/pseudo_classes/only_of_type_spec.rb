require 'spec_helper'

describe 'CSS selector evaluation' do
  describe ':only-of-type pseudo class' do
    before do
      @document = parse('<root><a><c /></a><b><c /></b></root>')

      @root = @document.children[0]
      @c1   = @root.children[0].children[0]
      @c2   = @root.children[1].children[0]
    end

    it 'returns a node set containing <c> nodes' do
      expect(evaluate_css(@document, 'root a :only-of-type')).to eq(node_set(@c1))
    end
  end
end
