require 'spec_helper'

describe Oga::XPath::Compiler do
  before do
    @document = parse('<a xmlns:ns1="x"><b></b><b></b><ns1:c></ns1:c></a>')

    @a1 = @document.children[0]
    @b1 = @a1.children[0]
    @b2 = @a1.children[1]
    @c1 = @a1.children[2]
  end

  describe 'relative to a document' do
    describe 'a/*' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == @a1.children
      end
    end

    describe 'a/*:b' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == node_set(@b1, @b2)
      end
    end

    describe 'a/ns1:*' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == node_set(@c1)
      end
    end

    describe 'a/*:*' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == @a1.children
      end
    end
  end
end
