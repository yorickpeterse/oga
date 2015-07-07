require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'variable bindings' do
    before do
      @document = parse('<a></a>')
    end

    it 'evaluates a variable' do
      evaluator = described_class.new(@document, 'number' => 10.0)

      evaluator.evaluate('$number').should == 10.0
    end

    it 'raises RuntimeError when evaluating an unbound variable' do
      evaluator = described_class.new(@document)
      block     = lambda { evaluator.evaluate('$number') }

      block.should raise_error 'Undefined XPath variable: number'
    end
  end
end
