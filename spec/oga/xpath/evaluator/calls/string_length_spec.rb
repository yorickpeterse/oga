require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'string-length() function' do
    before do
      @document = parse('<root><a>x</a></root>')
    end

    example 'return the length of a literal string' do
      evaluate_xpath(@document, 'string-length("foo")').should == 3.0
    end

    example 'return the length of a literal integer' do
      evaluate_xpath(@document, 'string-length(10)').should == 2.0
    end

    example 'return the length of a literal float' do
      # This includes the counting of the dot. That is, "10.5".length => 4
      evaluate_xpath(@document, 'string-length(10.5)').should == 4.0
    end

    example 'return the length of a string in a node set' do
      evaluate_xpath(@document, 'string-length(root)').should == 1.0
    end

    example 'return a node set containing nodes with a specific text length' do
      evaluate_xpath(@document, 'root/a[string-length() = 1]')
        .should == node_set(@document.children[0].children[0])
    end
  end
end
