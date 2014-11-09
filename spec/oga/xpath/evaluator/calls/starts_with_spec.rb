require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'starts-with() function' do
    before do
      @document = parse('<root><a>foo</a><b>foobar</b></root>')
    end

    example 'return true if the 1st string starts with the 2nd string' do
      evaluate_xpath(@document, 'starts-with("foobar", "foo")').should == true
    end

    example "return false if the 1st string doesn't start with the 2nd string" do
      evaluate_xpath(@document, 'starts-with("foobar", "baz")').should == false
    end

    example 'return true if the 1st node set starts with the 2nd string' do
      evaluate_xpath(@document, 'starts-with(root/a, "foo")').should == true
    end

    example 'return true if the 1st node set starts with the 2nd node set' do
      evaluate_xpath(@document, 'starts-with(root/b, root/a)').should == true
    end

    example "return false if the 1st node set doesn't start with the 2nd string" do
      evaluate_xpath(@document, 'starts-with(root/a, "baz")').should == false
    end

    example 'return true if the 1st string starts with the 2nd node set' do
      evaluate_xpath(@document, 'starts-with("foobar", root/a)').should == true
    end

    example 'return true when using two empty strings' do
      evaluate_xpath(@document, 'starts-with("", "")').should == true
    end
  end
end
