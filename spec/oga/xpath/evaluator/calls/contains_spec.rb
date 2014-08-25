require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'contains() function' do
    before do
      @document  = parse('<root><a>foo</a><b>foobar</b></root>')
      @evaluator = described_class.new(@document)
    end

    example 'return true if the 1st string contains the 2nd string' do
      @evaluator.evaluate('contains("foobar", "oo")').should == true
    end

    example "return false if the 1st string doesn't contain the 2nd string" do
      @evaluator.evaluate('contains("foobar", "baz")').should == false
    end

    example 'return true if the 1st node set contains the 2nd string' do
      @evaluator.evaluate('contains(root/a, "oo")').should == true
    end

    example 'return true if the 1st node set contains the 2nd node set' do
      @evaluator.evaluate('contains(root/b, root/a)').should == true
    end

    example "return false if the 1st node doesn't contain the 2nd node set" do
      @evaluator.evaluate('contains(root/a, root/b)').should == false
    end

    example 'return true if the 1st string contains the 2nd node set' do
      @evaluator.evaluate('contains("foobar", root/a)').should == true
    end

    example 'return true when using two empty strings' do
      @evaluator.evaluate('contains("", "")').should == true
    end
  end
end
