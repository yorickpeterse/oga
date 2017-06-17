require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'substring-before() function' do
    before do
      @document = parse('<root><a>-</a><b>a-b-c</b></root>')

      @a1 = @document.children[0].children[0]
    end

    describe 'at the top-level' do
      it 'returns the substring of the 1st string before the 2nd string' do
        expect(evaluate_xpath(@document, 'substring-before("a-b-c", "-")')).to eq('a')
      end

      it 'returns an empty string if the 2nd string is not present' do
        expect(evaluate_xpath(@document, 'substring-before("a-b-c", "x")')).to eq('')
      end

      it 'returns the substring of the 1st node set before the 2nd string' do
        expect(evaluate_xpath(@document, 'substring-before(root/b, "-")')).to eq('a')
      end

      it 'returns the substring of the 1st node set before the 2nd node set' do
        expect(evaluate_xpath(@document, 'substring-before(root/b, root/a)'))
          .to eq('a')
      end

      it 'returns an empty string when using two empty strings' do
        expect(evaluate_xpath(@document, 'substring-before("", "")')).to eq('')
      end
    end

    describe 'in a predicate' do
      it 'returns a NodeSet containing all matching nodes' do
        expect(evaluate_xpath(@document, 'root/a[substring-before("foo-bar", "-")]'))
          .to eq(node_set(@a1))
      end
    end
  end
end
