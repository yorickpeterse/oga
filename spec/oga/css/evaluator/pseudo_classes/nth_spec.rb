require 'spec_helper'

describe 'CSS selector evaluation' do
  describe ':nth pseudo class' do
    before do
      @document = parse('<root><a /><a /></root>')

      @root = @document.children[0]
      @a1   = @root.children[0]
      @a2   = @root.children[1]
    end

    it 'returns a node set containing the first <a> node' do
      evaluate_css(@document, 'root a:nth(1)').should == node_set(@a1)
    end

    it 'returns a node set containing the second <a> node' do
      evaluate_css(@document, 'root a:nth(2)').should == node_set(@a2)
    end
  end
end
