require 'spec_helper'

describe 'CSS selector evaluation' do
  describe 'IDs' do
    before do
      @document = parse('<x id="foo" />')
    end

    it 'returns a node set containing a node with a single ID' do
      expect(evaluate_css(@document, '#foo')).to eq(@document.children)
    end

    it 'returns an empty node set for non matching IDs' do
      expect(evaluate_css(@document, '#bar')).to eq(node_set)
    end
  end
end
