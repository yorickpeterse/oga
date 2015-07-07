require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'boolean() function' do
    before do
      @document = parse('<root><a>foo</a></root>')
    end

    it 'returns true for a non empty string literal' do
      evaluate_xpath(@document, 'boolean("foo")').should == true
    end

    it 'returns false for an empty string' do
      evaluate_xpath(@document, 'boolean("")').should == false
    end

    it 'returns true for a positive integer' do
      evaluate_xpath(@document, 'boolean(10)').should == true
    end

    it 'returns true for a boolean true' do
      evaluate_xpath(@document, 'boolean(true())').should == true
    end

    it 'returns false for a boolean false' do
      evaluate_xpath(@document, 'boolean(false())').should == false
    end

    it 'returns true for a positive float' do
      evaluate_xpath(@document, 'boolean(10.5)').should == true
    end

    it 'returns true for a negative integer' do
      evaluate_xpath(@document, 'boolean(-5)').should == true
    end

    it 'returns true for a negative float' do
      evaluate_xpath(@document, 'boolean(-5.2)').should == true
    end

    it 'returns false for a zero integer' do
      evaluate_xpath(@document, 'boolean(0)').should == false
    end

    it 'returns false for a zero float' do
      evaluate_xpath(@document, 'boolean(0.0)').should == false
    end

    it 'returns true for a non empty node set' do
      evaluate_xpath(@document, 'boolean(root/a)').should == true
    end

    it 'returns false for an empty node set' do
      evaluate_xpath(@document, 'boolean(root/b)').should == false
    end
  end
end
