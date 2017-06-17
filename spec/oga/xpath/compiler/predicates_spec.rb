require 'spec_helper'

describe Oga::XPath::Compiler do
  before do
    @document = parse('<root><a>10</a><a><b>20</a></a></root>')

    root = @document.children[0]

    @a1 = root.children[0]
    @a2 = root.children[1]
  end

  describe 'relative to a document' do
    describe 'root/a[1]' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@a1))
      end
    end

    describe 'root/a[1.5]' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@a1))
      end
    end

    describe 'root/a[b]' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@a2))
      end
    end
  end
end
