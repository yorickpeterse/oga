require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'float types' do
    before do
      @document = parse('')
    end

    example 'return a float' do
      evaluate_xpath(@document, '1.2').should == 1.2
    end

    example 'return a negative float' do
      evaluate_xpath(@document, '-1.2').should == -1.2
    end

    example 'return floats as a Float' do
      evaluate_xpath(@document, '1.2').is_a?(Float).should == true
    end
  end
end
