require 'spec_helper'

describe 'CSS selector evaluation' do
  describe 'classes' do
    it 'returns a node set containing a node with a single class' do
      document = parse('<x class="foo" />')

      evaluate_css(document, '.foo').should == document.children
    end

    it 'returns a node set containing a node having one of two classes' do
      document = parse('<x class="foo bar" />')

      evaluate_css(document, '.foo').should == document.children
    end

    it 'returns a node set containing a node having both classes' do
      document = parse('<x class="foo bar" />')

      evaluate_css(document, '.foo.bar').should == document.children
    end

    it 'returns an empty node set for non matching classes' do
      document = parse('<x class="bar" />')

      evaluate_css(document, '.foo').should == node_set
    end
  end
end
