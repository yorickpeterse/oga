require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'float types' do
    before do
      document  = parse('<a></a>')
      evaluator = described_class.new(document)
      @number   = evaluator.evaluate('1.2')
    end

    example 'return literal integers' do
      @number.should == 1.2
    end

    example 'return integers as floats' do
      @number.is_a?(Float).should == true
    end
  end
end
