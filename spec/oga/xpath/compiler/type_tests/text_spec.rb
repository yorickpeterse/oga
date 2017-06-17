require 'spec_helper'

describe Oga::XPath::Compiler do
  before do
    @document = parse('<a>foo<b>bar</b></a>')

    @text1 = @document.children[0].children[0]
    @text2 = @document.children[0].children[1].children[0]
  end

  describe 'relative to a document' do
    describe 'a/text()' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@text1))
      end
    end

    describe 'a/b/text()' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@text2))
      end
    end
  end
end
