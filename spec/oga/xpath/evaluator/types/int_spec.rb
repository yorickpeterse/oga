require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'integer types' do
    before do
      @document = parse('')
    end

    example 'return an integer' do
      evaluate_xpath(@document, '1').should == 1
    end

    example 'return a negative integer' do
      evaluate_xpath(@document, '-2').should == -2
    end

    example 'return integers as a Float' do
      evaluate_xpath(@document, '1').is_a?(Float).should == true
    end
  end
end
