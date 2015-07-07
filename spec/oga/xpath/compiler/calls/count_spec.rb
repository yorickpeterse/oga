require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'count() function' do
    before do
      @document = parse('<root><a><b></b></a><a></a></root>')
    end

    it 'returns the amount of nodes as a Float' do
      evaluate_xpath(@document, 'count(root)').is_a?(Float).should == true
    end

    it 'counts the amount of <root> nodes' do
      evaluate_xpath(@document, 'count(root)').should == 1
    end

    it 'counts the amount of <a> nodes' do
      evaluate_xpath(@document, 'count(root/a)').should == 2
    end

    it 'counts the amount of <b> nodes' do
      evaluate_xpath(@document, 'count(root/a/b)').should == 1
    end

    it 'raises ArgumentError if no arguments are given' do
      block = -> { evaluate_xpath(@document, 'count()') }

      block.should raise_error(ArgumentError)
    end

    it 'raises TypeError if the argument is not a NodeSet' do
      block = -> { evaluate_xpath(@document, 'count(1)') }

      block.should raise_error(TypeError)
    end
  end
end
