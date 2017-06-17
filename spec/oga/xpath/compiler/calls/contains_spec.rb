require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'contains() function' do
    before do
      @document = parse('<root><a>foo</a><b>foobar</b></root>')

      @a1 = @document.children[0].children[0]
    end

    describe 'at the top-level' do
      it 'returns true if the 1st string contains the 2nd string' do
        expect(evaluate_xpath(@document, 'contains("foobar", "oo")')).to eq(true)
      end

      it "returns false if the 1st string doesn't contain the 2nd string" do
        expect(evaluate_xpath(@document, 'contains("foobar", "baz")')).to eq(false)
      end

      it 'returns true if the 1st node set contains the 2nd string' do
        expect(evaluate_xpath(@document, 'contains(root/a, "oo")')).to eq(true)
      end

      it 'returns true if the 1st node set contains the 2nd node set' do
        expect(evaluate_xpath(@document, 'contains(root/b, root/a)')).to eq(true)
      end

      it "returns false if the 1st node doesn't contain the 2nd node set" do
        expect(evaluate_xpath(@document, 'contains(root/a, root/b)')).to eq(false)
      end

      it 'returns true if the 1st string contains the 2nd node set' do
        expect(evaluate_xpath(@document, 'contains("foobar", root/a)')).to eq(true)
      end

      it 'returns true when using two empty strings' do
        expect(evaluate_xpath(@document, 'contains("", "")')).to eq(true)
      end
    end

    describe 'in a predicate' do
      it 'returns a NodeSet containing all matching nodes' do
        expect(evaluate_xpath(@document, 'root/a[contains("foo", "foo")]'))
          .to eq(node_set(@a1))
      end
    end
  end
end
