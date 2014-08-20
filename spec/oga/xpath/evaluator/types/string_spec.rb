require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'string types' do
    before do
      document  = parse('<a></a>')
      evaluator = described_class.new(document)
      @string   = evaluator.evaluate('"foo"')
    end

    example 'return the literal string' do
      @string.should == 'foo'
    end
  end
end
