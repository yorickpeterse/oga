require 'spec_helper'

describe 'CSS selector evaluation' do
  context ':last-of-type pseudo class' do
    before do
      @document = parse('<root><a /><b /><a /></root>')

      @b1 = @document.children[0].children[1]
      @a2 = @document.children[0].children[2]
    end

    example 'return a node set containing the last node' do
      evaluate_css(@document, 'root :last-of-type').should == node_set(@a2)
    end

    example 'return a node set containing the last node with a node test' do
      evaluate_css(@document, 'root b:last-of-type').should == node_set(@b1)
    end

    example 'return a node set containing the last <a> node' do
      evaluate_css(@document, 'root a:last-of-type').should == node_set(@a2)
    end
  end
end
