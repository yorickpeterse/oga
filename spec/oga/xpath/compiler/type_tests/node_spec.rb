require 'spec_helper'

describe Oga::XPath::Compiler do
  before do
    @document = parse('<a><b>foo</b><!--foo--><![CDATA[bar]]></a>')

    @a1       = @document.children[0]
    @b1       = @a1.children[0]
    @comment1 = @a1.children[1]
    @cdata1   = @a1.children[2]
  end

  describe 'relative to a document' do
    describe 'node()' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@a1))
      end
    end

    describe 'a/node()' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@b1, @comment1, @cdata1))
      end
    end

    describe 'a/b/node()' do
      it 'returns NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@b1.children[0]))
      end
    end

    describe 'node()/b' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@b1))
      end
    end
  end
end
