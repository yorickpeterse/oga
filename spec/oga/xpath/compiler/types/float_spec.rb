require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'float types' do
    before do
      @document = parse('')
    end

    it 'returns a float' do
      evaluate_xpath(@document, '1.2').should == 1.2
    end

    it 'returns a negative float' do
      evaluate_xpath(@document, '-1.2').should == -1.2
    end

    it 'returns floats as a Float' do
      evaluate_xpath(@document, '1.2').is_a?(Float).should == true
    end
  end
end
