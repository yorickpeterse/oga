require 'spec_helper'

describe Oga::XPath::Compiler do
  before do
    @document = parse('<a><b></b></a>')

    @a1 = @document.children[0]
    @b1 = @a1.children[0]
  end

  describe 'relative to a document' do
    describe 'child::a' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == node_set(@a1)
      end
    end

    describe 'child::a/child::b' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == node_set(@b1)
      end
    end
  end

  describe 'relative to an element' do
    describe 'child::a' do
      it 'returns an empty NodeSet' do
        evaluate_xpath(@a1).should == node_set
      end
    end

    describe 'child::b' do
      it 'returns a NodeSet' do
        evaluate_xpath(@a1).should == node_set(@b1)
      end
    end

    describe 'child::x' do
      it 'returns an empty NodeSet' do
        evaluate_xpath(@a1).should == node_set
      end
    end
  end
end
