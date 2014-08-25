require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'substring-after() function' do
    before do
      @document  = parse('<root><a>-</a><b>a-b-c</b></root>')
      @evaluator = described_class.new(@document)
    end

    example 'return the substring of the 1st string after the 2nd string' do
      @evaluator.evaluate('substring-after("a-b-c", "-")').should == 'b-c'
    end

    example 'return an empty string if the 2nd string is not present' do
      @evaluator.evaluate('substring-after("a-b-c", "x")').should == ''
    end

    example 'return the substring of the 1st node set after the 2nd string' do
      @evaluator.evaluate('substring-after(root/b, "-")').should == 'b-c'
    end

    example 'return the substring of the 1st node set after the 2nd node set' do
      @evaluator.evaluate('substring-after(root/b, root/a)').should == 'b-c'
    end

    example 'return an empty string when using two empty strings' do
      @evaluator.evaluate('substring-after("", "")').should == ''
    end
  end
end
