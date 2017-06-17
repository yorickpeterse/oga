require 'spec_helper'

describe 'CSS selector evaluation' do
  describe ':root pseudo class' do
    before do
      @document = parse('<root><a /></root>')
    end

    it 'returns a node set containing the root node' do
      expect(evaluate_css(@document, ':root')).to eq(@document.children)
    end
  end
end
