require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'position() function' do
    before do
      @document = parse('<root><a>foo</a><a>bar</a></root>')

      @a1 = @document.children[0].children[0]
      @a2 = @document.children[0].children[1]
    end

    it 'returns a node set containing the first node' do
      expect(evaluate_xpath(@document, 'root/a[position() = 1]'))
        .to eq(node_set(@a1))
    end

    it 'returns a node set containing the second node' do
      expect(evaluate_xpath(@document, 'root/a[position() = 2]'))
        .to eq(node_set(@a2))
    end
  end
end
