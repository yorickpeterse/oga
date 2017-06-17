require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'namespace-uri() function' do
    before do
      @document = parse('<root xmlns:x="y"><x:a></x:a><b x:num="10"></b></root>')
    end

    it 'returns the namespace URI of the <x:a> node' do
      expect(evaluate_xpath(@document, 'namespace-uri(root/x:a)')).to eq('y')
    end

    it 'returns the namespace URI of the "num" attribute' do
      expect(evaluate_xpath(@document, 'namespace-uri(root/b/@x:num)')).to eq('y')
    end

    it 'returns an empty string when there is no namespace URI' do
      expect(evaluate_xpath(@document, 'namespace-uri(root/b)')).to eq('')
    end

    it 'raises TypeError for invalid argument types' do
      block = -> { evaluate_xpath(@document, 'namespace-uri("foo")') }

      expect(block).to raise_error(TypeError)
    end

    it 'returns a node set containing nodes with a namespace URI' do
      expect(evaluate_xpath(@document, 'root/*[namespace-uri()]'))
        .to eq(node_set(@document.children[0].children[0]))
    end
  end
end
