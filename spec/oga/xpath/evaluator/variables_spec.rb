require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'variable bindings' do
    before do
      @document = parse('<a></a>')
    end

    example 'evaluate a variable' do
      evaluator = described_class.new(@document, 'number' => 10.0)

      evaluator.evaluate('$number').should == 10.0
    end

    example 'raise RuntimeError when evaluating an unbound variable' do
      evaluator = described_class.new(@document)
      block     = lambda { evaluator.evaluate('$number') }

      block.should raise_error 'Undefined XPath variable: number'
    end
  end
end
