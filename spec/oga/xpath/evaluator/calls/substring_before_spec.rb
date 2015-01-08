require 'spec_helper'

describe Oga::XPath::Evaluator do
  describe 'substring-before() function' do
    before do
      @document = parse('<root><a>-</a><b>a-b-c</b></root>')
    end

    it 'returns the substring of the 1st string before the 2nd string' do
      evaluate_xpath(@document, 'substring-before("a-b-c", "-")').should == 'a'
    end

    it 'returns an empty string if the 2nd string is not present' do
      evaluate_xpath(@document, 'substring-before("a-b-c", "x")').should == ''
    end

    it 'returns the substring of the 1st node set before the 2nd string' do
      evaluate_xpath(@document, 'substring-before(root/b, "-")').should == 'a'
    end

    it 'returns the substring of the 1st node set before the 2nd node set' do
      evaluate_xpath(@document, 'substring-before(root/b, root/a)')
        .should == 'a'
    end

    it 'returns an empty string when using two empty strings' do
      evaluate_xpath(@document, 'substring-before("", "")').should == ''
    end
  end
end
