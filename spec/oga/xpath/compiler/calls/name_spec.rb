require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'name() function' do
    before do
      @document = parse('<root xmlns:x="y"><x:a></x:a><b x:num="10"></b></root>')
    end

    it 'returns the name of the <x:a> node' do
      expect(evaluate_xpath(@document, 'name(root/x:a)')).to eq('x:a')
    end

    it 'returns the name of the <b> node' do
      expect(evaluate_xpath(@document, 'name(root/b)')).to eq('b')
    end

    it 'returns the local name for the "num" attribute' do
      expect(evaluate_xpath(@document, 'name(root/b/@x:num)')).to eq('x:num')
    end

    it 'returns only the name of the first node in the set' do
      expect(evaluate_xpath(@document, 'name(root/*)')).to eq('x:a')
    end

    it 'returns an empty string by default' do
      expect(evaluate_xpath(@document, 'name(foo)')).to eq('')
    end

    it 'raises a TypeError for invalid argument types' do
      block = -> { evaluate_xpath(@document, 'name("foo")') }

      expect(block).to raise_error(TypeError)
    end

    it 'returns a node set containing nodes with a name' do
      expect(evaluate_xpath(@document, 'root/b[name()]'))
        .to eq(node_set(@document.children[0].children[1]))
    end
  end
end
