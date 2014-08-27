require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'false() function' do
    before do
      @evaluator = described_class.new(parse(''))
    end

    example 'return false' do
      @evaluator.evaluate('false()').should == false
    end
  end
end
