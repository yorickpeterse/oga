require 'spec_helper'

describe 'CSS selector evaluation' do
  describe 'predicates' do
    before do
      @document = parse('<root><a class="foo" /></root>')

      @a1 = @document.children[0].children[0]
    end

    it 'returns a node set containing nodes with an attribute' do
      evaluate_css(@document, 'root a[class]').should == node_set(@a1)
    end

    it 'returns a node set containing nodes with a matching attribute value' do
      evaluate_css(@document, 'root a[class="foo"]').should == node_set(@a1)
    end
  end
end
