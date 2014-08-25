require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'substring() function' do
    before do
      @document  = parse('<root><a>foobar</a><b>3</b></root>')
      @evaluator = described_class.new(@document)
    end

    example 'return the substring of a string' do
      @evaluator.evaluate('substring("foo", 2)').should == 'oo'
    end

    example 'return the substring of a string using a custom length' do
      @evaluator.evaluate('substring("foo", 2, 1)').should == 'o'
    end

    example 'return the substring of a node set' do
      @evaluator.evaluate('substring(root/a, 2)').should == 'oobar'
    end

    example 'return the substring of a node set with a node set as the length' do
      @evaluator.evaluate('substring(root/a, 1, root/b)').should == 'foo'
    end

    example 'return an empty string when the source string is empty' do
      @evaluator.evaluate('substring("", 1, 3)').should == ''
    end
  end
end
