require 'spec_helper'

describe Oga::XPath::Evaluator do
  describe 'contains() function' do
    before do
      @document = parse('<root><a>foo</a><b>foobar</b></root>')
    end

    it 'returns true if the 1st string contains the 2nd string' do
      evaluate_xpath(@document, 'contains("foobar", "oo")').should == true
    end

    it "returns false if the 1st string doesn't contain the 2nd string" do
      evaluate_xpath(@document, 'contains("foobar", "baz")').should == false
    end

    it 'returns true if the 1st node set contains the 2nd string' do
      evaluate_xpath(@document, 'contains(root/a, "oo")').should == true
    end

    it 'returns true if the 1st node set contains the 2nd node set' do
      evaluate_xpath(@document, 'contains(root/b, root/a)').should == true
    end

    it "returns false if the 1st node doesn't contain the 2nd node set" do
      evaluate_xpath(@document, 'contains(root/a, root/b)').should == false
    end

    it 'returns true if the 1st string contains the 2nd node set' do
      evaluate_xpath(@document, 'contains("foobar", root/a)').should == true
    end

    it 'returns true when using two empty strings' do
      evaluate_xpath(@document, 'contains("", "")').should == true
    end
  end
end
