require 'spec_helper'

describe Oga::XPath::Compiler do
  before do
    @document = parse('<a><!--foo--><b><!--bar--></b></a>')

    @comment1 = @document.children[0].children[0]
    @comment2 = @document.children[0].children[1].children[0]
  end

  describe 'relative to a document' do
    describe 'a/comment()' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == node_set(@comment1)
      end
    end

    describe 'a/b/comment()' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == node_set(@comment2)
      end
    end
  end
end
