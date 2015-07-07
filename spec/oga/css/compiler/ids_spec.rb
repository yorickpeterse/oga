require 'spec_helper'

describe 'CSS selector evaluation' do
  describe 'IDs' do
    before do
      @document = parse('<x id="foo" />')
    end

    it 'returns a node set containing a node with a single ID' do
      evaluate_css(@document, '#foo').should == @document.children
    end

    it 'returns an empty node set for non matching IDs' do
      evaluate_css(@document, '#bar').should == node_set
    end
  end
end
