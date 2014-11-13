require 'spec_helper'

describe 'CSS selector evaluation' do
  context ':first-of-type pseudo class' do
    before do
      @document = parse('<root><a /><b /></root>')

      @a1 = @document.children[0].children[0]
      @b1 = @document.children[0].children[1]
    end

    example 'return a node set containing the first node' do
      evaluate_css(@document, 'root :first-of-type').should == node_set(@a1)
    end

    example 'return a node set containing the first node with a node test' do
      evaluate_css(@document, 'root a:first-of-type').should == node_set(@a1)
    end

    example 'return a node set containing the first <b> node' do
      evaluate_css(@document, 'root b:first-of-type').should == node_set(@b1)
    end
  end
end
