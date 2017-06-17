require 'spec_helper'

describe 'CSS selector evaluation' do
  describe 'operators' do
    describe '= operator' do
      before do
        @document = parse('<x a="b" />')
      end

      it 'returns a node set containing nodes with matching attributes' do
        expect(evaluate_css(@document, 'x[a = "b"]')).to eq(@document.children)
      end

      it 'returns an empty node set for non matching attribute values' do
        expect(evaluate_css(@document, 'x[a = "c"]')).to eq(node_set)
      end
    end

    describe '~= operator' do
      it 'returns a node set containing nodes with matching attributes' do
        document = parse('<x a="1 2 3" />')

        expect(evaluate_css(document, 'x[a ~= "2"]')).to eq(document.children)
      end

      it 'returns a node set containing nodes with single attribute values' do
        document = parse('<x a="1" />')

        expect(evaluate_css(document, 'x[a ~= "1"]')).to eq(document.children)
      end

      it 'returns an empty node set for non matching attributes' do
        document = parse('<x a="1 2 3" />')

        expect(evaluate_css(document, 'x[a ~= "4"]')).to eq(node_set)
      end
    end

    describe '^= operator' do
      before do
        @document = parse('<x a="foo" />')
      end

      it 'returns a node set containing nodes with matching attributes' do
        expect(evaluate_css(@document, 'x[a ^= "fo"]')).to eq(@document.children)
      end

      it 'returns an empty node set for non matching attributes' do
        expect(evaluate_css(@document, 'x[a ^= "bar"]')).to eq(node_set)
      end
    end

    describe '$= operator' do
      before do
        @document = parse('<x a="foo" />')
      end

      it 'returns a node set containing nodes with matching attributes' do
        expect(evaluate_css(@document, 'x[a $= "oo"]')).to eq(@document.children)
      end

      it 'returns an empty node set for non matching attributes' do
        expect(evaluate_css(@document, 'x[a $= "x"]')).to eq(node_set)
      end
    end

    describe '*= operator' do
      before do
        @document = parse('<x a="foo" />')
      end

      it 'returns a node set containing nodes with matching attributes' do
        expect(evaluate_css(@document, 'x[a *= "o"]')).to eq(@document.children)
      end

      it 'returns an empty node set for non matching attributes' do
        expect(evaluate_css(@document, 'x[a *= "x"]')).to eq(node_set)
      end
    end

    describe '|= operator' do
      it 'returns a node set containing nodes with matching attributes' do
        document = parse('<x a="foo-bar" />')

        expect(evaluate_css(document, 'x[a |= "foo"]')).to eq(document.children)
      end

      it 'returns a node set containing nodes with single attribute values' do
        document = parse('<x a="foo" />')

        expect(evaluate_css(document, 'x[a |= "foo"]')).to eq(document.children)
      end

      it 'returns an empty node set for non matching attributes' do
        document = parse('<x a="bar" />')

        expect(evaluate_css(document, 'x[a |= "foo"]')).to eq(node_set)
      end
    end
  end
end
