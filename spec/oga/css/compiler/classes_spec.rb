require 'spec_helper'

describe 'CSS selector evaluation' do
  describe 'classes' do
    it 'returns a node set containing a node with a single class' do
      document = parse('<x class="foo" />')

      expect(evaluate_css(document, '.foo')).to eq(document.children)
    end

    it 'returns a node set containing a node having one of two classes' do
      document = parse('<x class="foo bar" />')

      expect(evaluate_css(document, '.foo')).to eq(document.children)
    end

    it 'returns a node set containing a node having both classes' do
      document = parse('<x class="foo bar" />')

      expect(evaluate_css(document, '.foo.bar')).to eq(document.children)
    end

    it 'returns an empty node set for non matching classes' do
      document = parse('<x class="bar" />')

      expect(evaluate_css(document, '.foo')).to eq(node_set)
    end
  end
end
