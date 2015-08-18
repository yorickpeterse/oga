require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'not() function' do
    before do
      @document = parse('<root>foo</root>')

      @root = @document.children[0]
    end

    describe 'at the top-level' do
      it 'returns false when the argument is a non-zero integer' do
        evaluate_xpath(@document, 'not(10)').should == false
      end

      it 'returns true when the argument is a zero integer' do
        evaluate_xpath(@document, 'not(0)').should == true
      end

      it 'returns false when the argument is a non-empty node set' do
        evaluate_xpath(@document, 'not(root)').should == false
      end

      it 'returns itrue when the argument is an empty node set' do
        evaluate_xpath(@document, 'not(foo)').should == true
      end
    end

    describe 'in a predicate' do
      it 'returns a NodeSet containing all matching nodes ' do
        evaluate_xpath(@document, 'root[not(comment())]')
          .should == node_set(@root)
      end
    end
  end
end
