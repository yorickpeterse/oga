require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'pipe operator' do
    before do
      @document = parse('<root><a></a><b></b><c></c></root>')

      @root = @document.children[0]
      @a1   = @root.children[0]
      @b1   = @root.children[1]
      @c1   = @root.children[2]
    end

    it 'merges two node sets' do
      evaluate_xpath(@document, 'root/a | root/b').should == node_set(@a1, @b1)
    end

    it 'merges two sets when the left hand side is empty' do
      evaluate_xpath(@document, 'foo | root/b').should == node_set(@b1)
    end

    it 'merges two sets when the right hand side is empty' do
      evaluate_xpath(@document, 'root/a | foo').should == node_set(@a1)
    end

    it 'merges two identical sets' do
      evaluate_xpath(@document, 'root/a | root/a').should == node_set(@a1)
    end

    it 'merges three sets' do
      evaluate_xpath(@document, 'root/a | root/b | root/c')
        .should == node_set(@a1, @b1, @c1)
    end

    it 'merges three identical sets' do
      evaluate_xpath(@document, 'root/a | root/a | root/a')
        .should == node_set(@a1)
    end

    it 'merges two non-empty sets in a predicate' do
      evaluate_xpath(@document, 'root[a | b]').should == node_set(@root)
    end

    it 'merges three non-empty sets in a predicate' do
      evaluate_xpath(@document, 'root[a | b | c]').should == node_set(@root)
    end

    it 'merges two empty sets in a predicate' do
      evaluate_xpath(@document, 'root[x | y]').should == node_set
    end

    it 'merges three empty sets in a predicate' do
      evaluate_xpath(@document, 'root[x | y | z]').should == node_set
    end
  end
end
