require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'string-length() function' do
    before do
      @document = parse('<root><a>x</a></root>')
    end

    it 'returns the length of a literal string' do
      expect(evaluate_xpath(@document, 'string-length("foo")')).to eq(3.0)
    end

    it 'returns the length of a literal integer' do
      expect(evaluate_xpath(@document, 'string-length(10)')).to eq(2.0)
    end

    it 'returns the length of a literal float' do
      # This includes the counting of the dot. That is, "10.5".length => 4
      expect(evaluate_xpath(@document, 'string-length(10.5)')).to eq(4.0)
    end

    it 'returns the length of a string in a node set' do
      expect(evaluate_xpath(@document, 'string-length(root)')).to eq(1.0)
    end

    it 'returns a node set containing nodes with a specific text length' do
      expect(evaluate_xpath(@document, 'root/a[string-length() = 1]'))
        .to eq(node_set(@document.children[0].children[0]))
    end
  end
end
