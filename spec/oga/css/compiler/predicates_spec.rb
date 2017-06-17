require 'spec_helper'

describe 'CSS selector evaluation' do
  describe 'predicates' do
    before do
      @document = parse('<root><a class="foo" /></root>')

      @a1 = @document.children[0].children[0]
    end

    it 'returns a node set containing nodes with an attribute' do
      expect(evaluate_css(@document, 'root a[class]')).to eq(node_set(@a1))
    end

    it 'returns a node set containing nodes with a matching attribute value' do
      expect(evaluate_css(@document, 'root a[class="foo"]')).to eq(node_set(@a1))
    end
  end
end
