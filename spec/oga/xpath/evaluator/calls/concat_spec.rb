require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'concat() function' do
    before do
      @document  = parse('<root><a>foo</a><b>bar</b></root>')
      @evaluator = described_class.new(@document)
    end

    example 'concatenate two strings' do
      @evaluator.evaluate('concat("foo", "bar")').should == 'foobar'
    end

    example 'concatenate two integers' do
      @evaluator.evaluate('concat(10, 20)').should == '1020'
    end

    example 'concatenate two floats' do
      @evaluator.evaluate('concat(10.5, 20.5)').should == '10.520.5'
    end

    example 'concatenate two node sets' do
      @evaluator.evaluate('concat(root/a, root/b)').should == 'foobar'
    end

    example 'concatenate a node set and a string' do
      @evaluator.evaluate('concat(root/a, "baz")').should == 'foobaz'
    end
  end
end
