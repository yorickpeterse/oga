require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'substring-before() function' do
    before do
      @document  = parse('<root><a>-</a><b>a-b-c</b></root>')
      @evaluator = described_class.new(@document)
    end

    example 'return the substring of the 1st string before the 2nd string' do
      @evaluator.evaluate('substring-before("a-b-c", "-")').should == 'a'
    end

    example 'return an empty string if the 2nd string is not present' do
      @evaluator.evaluate('substring-before("a-b-c", "x")').should == ''
    end

    example 'return the substring of the 1st node set before the 2nd string' do
      @evaluator.evaluate('substring-before(root/b, "-")').should == 'a'
    end

    example 'return the substring of the 1st node set before the 2nd node set' do
      @evaluator.evaluate('substring-before(root/b, root/a)').should == 'a'
    end

    example 'return an empty string when using two empty strings' do
      @evaluator.evaluate('substring-before("", "")').should == ''
    end
  end
end
