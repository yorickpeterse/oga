require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'comment() tests' do
    before do
      @document = parse('<a><!--foo--><b><!--bar--></b></a>')

      @comment1 = @document.children[0].children[0]
      @comment2 = @document.children[0].children[1].children[0]
    end

    example 'return a node set containing comment nodes' do
      evaluate_xpath(@document, 'a/comment()').should == node_set(@comment1)
    end

    example 'return a node set containing nested comments' do
      evaluate_xpath(@document, 'a/b/comment()').should == node_set(@comment2)
    end
  end
end
