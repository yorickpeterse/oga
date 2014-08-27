require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'true() function' do
    before do
      @evaluator = described_class.new(parse(''))
    end

    example 'return true' do
      @evaluator.evaluate('true()').should == true
    end
  end
end
