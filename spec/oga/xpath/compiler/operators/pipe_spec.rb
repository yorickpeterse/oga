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
      expect(evaluate_xpath(@document, 'root/a | root/b')).to eq(node_set(@a1, @b1))
    end

    it 'merges two sets when the left hand side is empty' do
      expect(evaluate_xpath(@document, 'foo | root/b')).to eq(node_set(@b1))
    end

    it 'merges two sets when the right hand side is empty' do
      expect(evaluate_xpath(@document, 'root/a | foo')).to eq(node_set(@a1))
    end

    it 'merges two identical sets' do
      expect(evaluate_xpath(@document, 'root/a | root/a')).to eq(node_set(@a1))
    end

    it 'merges three sets' do
      expect(evaluate_xpath(@document, 'root/a | root/b | root/c'))
        .to eq(node_set(@a1, @b1, @c1))
    end

    it 'merges three identical sets' do
      expect(evaluate_xpath(@document, 'root/a | root/a | root/a'))
        .to eq(node_set(@a1))
    end

    it 'merges two non-empty sets in a predicate' do
      expect(evaluate_xpath(@document, 'root[a | b]')).to eq(node_set(@root))
    end

    it 'merges three non-empty sets in a predicate' do
      expect(evaluate_xpath(@document, 'root[a | b | c]')).to eq(node_set(@root))
    end

    it 'merges two empty sets in a predicate' do
      expect(evaluate_xpath(@document, 'root[x | y]')).to eq(node_set)
    end

    it 'merges three empty sets in a predicate' do
      expect(evaluate_xpath(@document, 'root[x | y | z]')).to eq(node_set)
    end
  end
end
