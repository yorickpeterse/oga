require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'integer types' do
    before do
      @document = parse('')
    end

    it 'returns an integer' do
      evaluate_xpath(@document, '1').should == 1
    end

    it 'returns a negative integer' do
      evaluate_xpath(@document, '-2').should == -2
    end

    it 'returns integers as a Float' do
      evaluate_xpath(@document, '1').is_a?(Float).should == true
    end
  end
end
