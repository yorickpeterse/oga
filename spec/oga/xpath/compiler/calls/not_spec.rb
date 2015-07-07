require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'not() function' do
    before do
      @document = parse('<root>foo</root>')
    end

    it 'returns false when the argument is a non-zero integer' do
      evaluate_xpath(@document, 'not(10)').should == false
    end

    it 'returns true when the argument is a zero integer' do
      evaluate_xpath(@document, 'not(0)').should == true
    end

    it 'returns false when the argument is a non-empty node set' do
      evaluate_xpath(@document, 'not(root)').should == false
    end

    it 'returns itrue when the argument is an empty node set' do
      evaluate_xpath(@document, 'not(foo)').should == true
    end
  end
end
