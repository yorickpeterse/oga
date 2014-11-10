require 'spec_helper'

context 'CSS selector evaluation' do
  context 'predicates' do
    before do
      @document = parse('<root><a class="foo" /></root>')

      @a1 = @document.children[0].children[0]
    end

    example 'return a node set containing nodes with an attribute' do
      evaluate_css(@document, 'root a[class]').should == node_set(@a1)
    end

    example 'return a node set containing nodes with a matching attribute value' do
      evaluate_css(@document, 'root a[class="foo"]').should == node_set(@a1)
    end
  end
end
