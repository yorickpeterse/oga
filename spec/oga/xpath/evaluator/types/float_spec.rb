require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'float types' do
    before do
      document   = parse('<a></a>')
      @evaluator = described_class.new(document)
    end

    example 'return a float' do
      @evaluator.evaluate('1.2').should == 1.2
    end

    example 'return a negative float' do
      @evaluator.evaluate('-1.2').should == -1.2
    end

    example 'return floats as a Float' do
      @evaluator.evaluate('1.2').is_a?(Float).should == true
    end
  end
end
