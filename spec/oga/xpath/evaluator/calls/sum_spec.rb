require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'sum() spec' do
    before do
      @document = parse('<root><a>1</a><b>2</b></root>')
    end

    example 'return the sum of the <root> node' do
      # The test of <root> is "12", which is then converted to a number.
      evaluate_xpath(@document, 'sum(root)').should == 12.0
    end

    example 'return the sum of the child nodes of the <root> node' do
      evaluate_xpath(@document, 'sum(root/*)').should == 3.0
    end

    example 'return zero by default' do
      evaluate_xpath(@document, 'sum(foo)').should be_zero
    end

    example 'raise a TypeError for non node set arguments' do
      block = -> { evaluate_xpath(@document, 'sum("foo")') }

      block.should raise_error(TypeError)
    end
  end
end
