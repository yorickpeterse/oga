require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'integer types' do
    before do
      document  = parse('<a></a>')
      evaluator = described_class.new(document)
      @number   = evaluator.evaluate('1')
    end

    example 'return literal integers' do
      @number.should == 1
    end

    example 'return integers as Fixnums' do
      @number.is_a?(Fixnum).should == true
    end
  end
end
