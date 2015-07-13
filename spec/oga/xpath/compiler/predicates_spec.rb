require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'predicates' do
    before do
      @document = parse('<root><a>10</a><a><b>20</a></a></root>')

      root = @document.children[0]

      @a1 = root.children[0]
      @a2 = root.children[1]
    end

    describe 'using an integer as an index' do
      it 'returns a NodeSet containing the first <a> node' do
        evaluate_xpath(@document, 'root/a[1]').should == node_set(@a1)
      end
    end

    describe 'using a float as an index' do
      it 'returns a NodeSet containing the first <a> node' do
        evaluate_xpath(@document, 'root/a[1.5]').should == node_set(@a1)
      end
    end

    describe 'using a node test' do
      it 'returns a NodeSet containing all <a> nodes with <b> child nodes' do
        evaluate_xpath(@document, 'root/a[b]').should == node_set(@a2)
      end
    end
  end
end
