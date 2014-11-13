require 'spec_helper'

describe 'CSS selector evaluation' do
  context ':root pseudo class' do
    before do
      @document = parse('<root><a /></root>')
    end

    example 'return a node set containing the root node' do
      evaluate_css(@document, ':root').should == @document.children
    end
  end
end
