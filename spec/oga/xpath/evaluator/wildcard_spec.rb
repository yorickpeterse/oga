require 'spec_helper'

describe Oga::XPath::Evaluator do
  describe 'wildcard paths' do
    before do
      @document = parse('<a xmlns:ns1="x"><b></b><b></b><ns1:c></ns1:c></a>')

      @a1 = @document.children[0]
      @b1 = @a1.children[0]
      @b2 = @a1.children[1]
      @c1 = @a1.children[2]
    end

    it 'evaluates a wildcard path' do
      evaluate_xpath(@document, 'a/*').should == @a1.children
    end

    it 'evaluates a path using a namespace wildcard' do
      evaluate_xpath(@document, 'a/*:b').should == node_set(@b1, @b2)
    end

    it 'evaluates a path using a namespace and a name wildcard' do
      evaluate_xpath(@document, 'a/ns1:*').should == node_set(@c1)
    end

    it 'evaluates a containing a namespace wildcard and a name wildcard' do
      evaluate_xpath(@document, 'a/*:*').should == @a1.children
    end
  end
end
