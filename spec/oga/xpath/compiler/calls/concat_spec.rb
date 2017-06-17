require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'concat() function' do
    before do
      @document = parse('<root><a>foo</a><b>bar</b></root>')
    end

    it 'concatenates two strings' do
      expect(evaluate_xpath(@document, 'concat("foo", "bar")')).to eq('foobar')
    end

    it 'concatenates two integers' do
      expect(evaluate_xpath(@document, 'concat(10, 20)')).to eq('1020')
    end

    it 'concatenates two floats' do
      expect(evaluate_xpath(@document, 'concat(10.5, 20.5)')).to eq('10.520.5')
    end

    it 'concatenates two node sets' do
      expect(evaluate_xpath(@document, 'concat(root/a, root/b)')).to eq('foobar')
    end

    it 'concatenates a node set and a string' do
      expect(evaluate_xpath(@document, 'concat(root/a, "baz")')).to eq('foobaz')
    end
  end
end
