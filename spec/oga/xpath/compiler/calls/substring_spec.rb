require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'substring() function' do
    before do
      @document = parse('<root><a>foobar</a><b>3</b></root>')

      @a1 = @document.children[0].children[0]
    end

    describe 'at the top-level' do
      it 'returns the substring of a string' do
        expect(evaluate_xpath(@document, 'substring("foo", 2)')).to eq('oo')
      end

      it 'returns the substring of a string using a custom length' do
        expect(evaluate_xpath(@document, 'substring("foo", 2, 1)')).to eq('o')
      end

      it 'returns the substring of a node set' do
        expect(evaluate_xpath(@document, 'substring(root/a, 2)')).to eq('oobar')
      end

      it 'returns the substring of a node set with a node set as the length' do
        expect(evaluate_xpath(@document, 'substring(root/a, 1, root/b)')).to eq('foo')
      end

      it 'returns an empty string when the source string is empty' do
        expect(evaluate_xpath(@document, 'substring("", 1, 3)')).to eq('')
      end
    end

    describe 'in a predicate' do
      it 'returns a NodeSet containing all matching nodes' do
        expect(evaluate_xpath(@document, 'root/a[substring("foo", 1, 2)]'))
          .to eq(node_set(@a1))
      end
    end
  end
end
