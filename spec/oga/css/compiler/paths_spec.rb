require 'spec_helper'

describe 'CSS selector evaluation' do
  describe 'paths' do
    before do
      @document = parse('<a xmlns:ns1="x"><b></b><b></b><ns1:c></ns1:c></a>')

      @a1 = @document.children[0]
      @b1 = @a1.children[0]
      @b2 = @a1.children[1]
      @c1 = @a1.children[2]
    end

    it 'returns a node set containing the root node' do
      evaluate_css(@document, 'a').should == node_set(@a1)
    end

    it 'returns a node set containing nested nodes' do
      evaluate_css(@document, 'a b').should == node_set(@b1, @b2)
    end

    it 'returns a node set containing the union of multiple paths' do
      evaluate_css(@document, 'b, ns1|c').should == node_set(@b1, @b2, @c1)
    end

    it 'returns a node set containing namespaced nodes' do
      evaluate_css(@document, 'a ns1|c').should == node_set(@c1)
    end

    it 'returns a node set containing wildcard nodes' do
      evaluate_css(@document, 'a *').should == node_set(@b1, @b2, @c1)
    end

    it 'returns a node set containing nodes with namespace wildcards' do
      evaluate_css(@document, 'a *|c')
    end

    it 'returns a node set containing nodes with a namespace name and name wildcard' do
      evaluate_css(@document, 'a ns1|*').should == node_set(@c1)
    end

    it 'returns a node set containing nodes using full wildcards' do
      evaluate_css(@document, 'a *|*').should == node_set(@b1, @b2, @c1)
    end
  end
end
