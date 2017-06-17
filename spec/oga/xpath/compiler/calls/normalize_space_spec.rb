require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'normalize-space() function' do
    before do
      @document = parse('<root><a> fo   o </a></root>')
    end

    it 'normalizes a literal string' do
      expect(evaluate_xpath(@document, 'normalize-space(" fo  o ")')).to eq('fo o')
    end

    it 'normalizes a string in a node set' do
      expect(evaluate_xpath(@document, 'normalize-space(root/a)')).to eq('fo o')
    end

    it 'normalizes an integer' do
      expect(evaluate_xpath(@document, 'normalize-space(10)')).to eq('10')
    end

    it 'normalizes a float' do
      expect(evaluate_xpath(@document, 'normalize-space(10.5)')).to eq('10.5')
    end

    it 'returns a node set containing nodes with normalized spaces' do
      expect(evaluate_xpath(@document, 'root/a[normalize-space()]'))
        .to eq(node_set(@document.children[0].children[0]))
    end
  end
end
