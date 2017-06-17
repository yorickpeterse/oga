require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'last() function' do
    before do
      @document = parse('<root><a>foo</a><a>bar</a></root>')

      @a1 = @document.children[0].children[0]
      @a2 = @document.children[0].children[1]
    end

    describe 'in a predicate' do
      it 'returns a NodeSet containing the last node' do
        expect(evaluate_xpath(@document, 'root/a[last()]')).to eq(node_set(@a2))
      end

      it 'returns a NodeSet matching all <a> nodes' do
        expect(evaluate_xpath(@document, 'root/a[1 < last()]'))
          .to eq(node_set(@a1, @a2))
      end
    end
  end
end
