require 'spec_helper'

describe 'CSS selector evaluation' do
  context 'operators' do
    context '= operator' do
      before do
        @document = parse('<x a="b" />')
      end

      example 'return a node set containing nodes with matching attributes' do
        evaluate_css(@document, 'x[a = "b"]').should == @document.children
      end

      example 'return an empty node set for non matching attribute values' do
        evaluate_css(@document, 'x[a = "c"]').should == node_set
      end
    end

    context '~= operator' do
      example 'return a node set containing nodes with matching attributes' do
        document = parse('<x a="1 2 3" />')

        evaluate_css(document, 'x[a ~= "2"]').should == document.children
      end

      example 'return a node set containing nodes with single attribute values' do
        document = parse('<x a="1" />')

        evaluate_css(document, 'x[a ~= "1"]').should == document.children
      end

      example 'return an empty node set for non matching attributes' do
        document = parse('<x a="1 2 3" />')

        evaluate_css(document, 'x[a ~= "4"]').should == node_set
      end
    end

    context '^= operator' do
      before do
        @document = parse('<x a="foo" />')
      end

      example 'return a node set containing nodes with matching attributes' do
        evaluate_css(@document, 'x[a ^= "fo"]').should == @document.children
      end

      example 'return an empty node set for non matching attributes' do
        evaluate_css(@document, 'x[a ^= "bar"]').should == node_set
      end
    end

    context '$= operator' do
      before do
        @document = parse('<x a="foo" />')
      end

      example 'return a node set containing nodes with matching attributes' do
        evaluate_css(@document, 'x[a $= "oo"]').should == @document.children
      end

      example 'return an empty node set for non matching attributes' do
        evaluate_css(@document, 'x[a $= "x"]').should == node_set
      end
    end

    context '*= operator' do
      before do
        @document = parse('<x a="foo" />')
      end

      example 'return a node set containing nodes with matching attributes' do
        evaluate_css(@document, 'x[a *= "o"]').should == @document.children
      end

      example 'return an empty node set for non matching attributes' do
        evaluate_css(@document, 'x[a *= "x"]').should == node_set
      end
    end

    context '|= operator' do
      example 'return a node set containing nodes with matching attributes' do
        document = parse('<x a="foo-bar" />')

        evaluate_css(document, 'x[a |= "foo"]').should == document.children
      end

      example 'return a node set containing nodes with single attribute values' do
        document = parse('<x a="foo" />')

        evaluate_css(document, 'x[a |= "foo"]').should == document.children
      end

      example 'return an empty node set for non matching attributes' do
        document = parse('<x a="bar" />')

        evaluate_css(document, 'x[a |= "foo"]').should == node_set
      end
    end
  end
end
