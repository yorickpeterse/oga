require 'spec_helper'

describe 'CSS selector evaluation' do
  context 'IDs' do
    before do
      @document = parse('<x id="foo" />')
    end

    example 'return a node set containing a node with a single ID' do
      evaluate_css(@document, '#foo').should == @document.children
    end

    example 'return an empty node set for non matching IDs' do
      evaluate_css(@document, '#bar').should == node_set
    end
  end
end
