require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'substring() function' do
    before do
      @document = parse('<root><a>foobar</a><b>3</b></root>')

      @a1 = @document.children[0].children[0]
    end

    describe 'at the top-level' do
      it 'returns the substring of a string' do
        evaluate_xpath(@document, 'substring("foo", 2)').should == 'oo'
      end

      it 'returns the substring of a string using a custom length' do
        evaluate_xpath(@document, 'substring("foo", 2, 1)').should == 'o'
      end

      it 'returns the substring of a node set' do
        evaluate_xpath(@document, 'substring(root/a, 2)').should == 'oobar'
      end

      it 'returns the substring of a node set with a node set as the length' do
        evaluate_xpath(@document, 'substring(root/a, 1, root/b)').should == 'foo'
      end

      it 'returns an empty string when the source string is empty' do
        evaluate_xpath(@document, 'substring("", 1, 3)').should == ''
      end
    end

    describe 'in a predicate' do
      it 'returns a NodeSet containing all matching nodes' do
        evaluate_xpath(@document, 'root/a[substring("foo", 1, 2)]')
          .should == node_set(@a1)
      end
    end
  end
end
