require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'sum() spec' do
    before do
      @document  = parse('<root><a>1</a><b>2</b></root>')
      @evaluator = described_class.new(@document)
    end

    example 'return the sum of the <root> node' do
      # The test of <root> is "12", which is then converted to a number.
      @evaluator.evaluate('sum(root)').should == 12.0
    end

    example 'return the sum of the child nodes of the <root> node' do
      @evaluator.evaluate('sum(root/*)').should == 3.0
    end

    example 'return zero by default' do
      @evaluator.evaluate('sum(foo)').should be_zero
    end
  end
end
