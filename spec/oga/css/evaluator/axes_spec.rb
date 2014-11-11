require 'spec_helper'

describe 'CSS selector evaluation' do
  context 'axes' do
    context '> axis' do
      before do
        @document = parse('<root><a><a /></a></root>')

        @a1 = @document.children[0].children[0]
      end

      example 'return a node set containing direct child nodes' do
        evaluate_css(@document, 'root > a').should == node_set(@a1)
      end

      example 'return a node set containing direct child nodes relative to a node' do
        evaluate_css(@a1, '> a').should == @a1.children
      end

      example 'return an empty node set for non matching child nodes' do
        evaluate_css(@document, '> a').should == node_set
      end
    end

    context '+ axis' do
      before do
        @document = parse('<root><a /><b /><b /></root>')

        @b1 = @document.children[0].children[1]
        @b2 = @document.children[0].children[2]
      end

      example 'return a node set containing following siblings' do
        evaluate_css(@document, 'root a + b').should == node_set(@b1)
      end

      example 'return a node set containing following siblings relatie to a node' do
        evaluate_css(@b1, '+ b').should == node_set(@b2)
      end

      example 'return an empty node set for non matching following siblings' do
        evaluate_css(@document, 'root a + c').should == node_set
      end
    end

    context '~ axis' do
      before do
        @document = parse('<root><a /><b /><b /></root>')

        @b1 = @document.children[0].children[1]
        @b2 = @document.children[0].children[2]
      end

      example 'return a node set containing following siblings' do
        evaluate_css(@document, 'root a ~ b').should == node_set(@b1, @b2)
      end

      example 'return a node set containing following siblings relative to a node' do
        evaluate_css(@b1, '~ b').should == node_set(@b2)
      end

      example 'return an empty node set for non matching following siblings' do
        evaluate_css(@document, 'root a ~ c').should == node_set
      end
    end
  end
end
