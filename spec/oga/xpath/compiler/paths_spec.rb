require 'spec_helper'

describe Oga::XPath::Compiler do
  before do
    @document = parse('<a xmlns:ns1="x">Foo<b></b><b></b><ns1:c></ns1:c></a>')

    @a1 = @document.children[0]
    @b1 = @a1.children[1]
    @b2 = @a1.children[2]
  end

  describe 'relative to a document' do
    describe '/a' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == node_set(@a1)
      end
    end

    describe '/A' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == node_set(@a1)
      end
    end

    describe '/' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == node_set(@document)
      end
    end

    describe 'a' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == node_set(@a1)
      end
    end

    describe 'x/a' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == node_set
      end
    end

    describe '/a/b' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == node_set(@b1, @b2)
      end
    end

    describe '/x/a' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == node_set
      end
    end

    describe 'a/ns1:c' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == node_set(@a1.children[-1])
      end
    end
  end

  describe 'relative to an element' do
    describe '/a' do
      it 'returns a NodeSet' do
        b_node = @document.children[0].children[0]

        evaluate_xpath(b_node, '/a').should == node_set(@a1)
      end
    end
  end
end
