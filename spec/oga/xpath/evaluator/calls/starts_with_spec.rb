require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'starts-with() function' do
    before do
      @document  = parse('<root><a>foo</a><b>foobar</b></root>')
      @evaluator = described_class.new(@document)
    end

    example 'return true if the 1st string starts with the 2nd string' do
      @evaluator.evaluate('starts-with("foobar", "foo")').should == true
    end

    example "return false if the 1st string doesn't start with the 2nd string" do
      @evaluator.evaluate('starts-with("foobar", "baz")').should == false
    end

    example 'return true if the 1st node set starts with the 2nd string' do
      @evaluator.evaluate('starts-with(root/a, "foo")').should == true
    end

    example 'return true if the 1st node set starts with the 2nd node set' do
      @evaluator.evaluate('starts-with(root/b, root/a)').should == true
    end

    example "return false if the 1st node set doesn't start with the 2nd string" do
      @evaluator.evaluate('starts-with(root/a, "baz")').should == false
    end

    example 'return true if the 1st string starts with the 2nd node set' do
      @evaluator.evaluate('starts-with("foobar", root/a)').should == true
    end

    example 'return true when using two empty strings' do
      @evaluator.evaluate('starts-with("", "")').should == true
    end
  end
end
