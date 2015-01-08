require 'spec_helper'

describe Oga::XPath::Evaluator do
  describe 'pipe operator' do
    before do
      @document = parse('<root><a></a><b></b></root>')

      @a1 = @document.children[0].children[0]
      @b1 = @document.children[0].children[1]
    end

    it 'merges two node sets' do
      evaluate_xpath(@document, 'root/a | root/b').should == node_set(@a1, @b1)
    end

    it 'merges two sets when the left hand side is empty' do
      evaluate_xpath(@document, 'foo | root/b').should == node_set(@b1)
    end

    it 'merges two sets when the right hand side is empty' do
      evaluate_xpath(@document, 'root/a | foo').should == node_set(@a1)
    end

    it 'merges two identical sets' do
      evaluate_xpath(@document, 'root/a | root/a').should == node_set(@a1)
    end
  end
end
