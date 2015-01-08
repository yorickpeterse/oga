require 'spec_helper'

describe Oga::XPath::Evaluator do
  describe 'position() function' do
    before do
      @document = parse('<root><a>foo</a><a>bar</a></root>')

      @a1 = @document.children[0].children[0]
      @a2 = @document.children[0].children[1]
    end

    it 'returns a node set containing the first node' do
      evaluate_xpath(@document, 'root/a[position() = 1]')
        .should == node_set(@a1)
    end

    it 'returns a node set containing the second node' do
      evaluate_xpath(@document, 'root/a[position() = 2]')
        .should == node_set(@a2)
    end
  end
end
