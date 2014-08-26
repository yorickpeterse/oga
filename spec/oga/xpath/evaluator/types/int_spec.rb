require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'integer types' do
    before do
      document   = parse('<a></a>')
      @evaluator = described_class.new(document)
    end

    example 'return an integer' do
      @evaluator.evaluate('1').should == 1
    end

    example 'return a negative integer' do
      @evaluator.evaluate('-2').should == -2
    end

    example 'return integers as a Float' do
      @evaluator.evaluate('1').is_a?(Float).should == true
    end
  end
end
