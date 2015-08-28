require 'spec_helper'

describe Oga::XPath::Compiler do
  before do
    @document = parse('<a foo="bar"><b><c></c></b><a></a></a>')

    @a1 = @document.children[0]
    @a2 = @a1.children[-1]
    @b1 = @a1.children[0]
    @c1 = @b1.children[0]
  end

  describe 'relative to a document' do
    describe 'descendant::a' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == node_set(@a1, @a2)
      end
    end

    describe 'descendant::c' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == node_set(@c1)
      end
    end

    describe 'a/descendant::a' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == node_set(@a2)
      end
    end

    describe 'descendant::a[1]' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == node_set(@a1)
      end
    end

    describe 'a/b/c/descendant::c' do
      it 'returns an empty NodeSet' do
        evaluate_xpath(@document).should == node_set
      end
    end
  end

  describe 'relative to an element' do
    describe 'descendant::b' do
      it 'returns a NodeSet' do
        evaluate_xpath(@a1).should == node_set(@b1)
      end
    end
  end

  describe 'relative to an attribute' do
    describe 'descendant::b' do
      it 'returns an empty NodeSet' do
        evaluate_xpath(@a1.attribute('foo')).should == node_set
      end
    end
  end
end
