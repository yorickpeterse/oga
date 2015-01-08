require 'spec_helper'

describe Oga::XPath::Evaluator do
  describe 'local-name() function' do
    before do
      @document = parse('<root xmlns:x="y"><x:a></x:a><b x:num="10"></b></root>')
    end

    it 'returns the local name of the <x:a> node' do
      evaluate_xpath(@document, 'local-name(root/x:a)').should == 'a'
    end

    it 'returns the local name of the <b> node' do
      evaluate_xpath(@document, 'local-name(root/b)').should == 'b'
    end

    it 'returns the local name for the "num" attribute' do
      evaluate_xpath(@document, 'local-name(root/b/@x:num)').should == 'num'
    end

    it 'returns only the name of the first node in the set' do
      evaluate_xpath(@document, 'local-name(root/*)').should == 'a'
    end

    it 'returns an empty string by default' do
      evaluate_xpath(@document, 'local-name(foo)').should == ''
    end

    it 'raises a TypeError for invalid argument types' do
      block = -> { evaluate_xpath(@document, 'local-name("foo")') }

      block.should raise_error(TypeError)
    end

    it 'returns a node set containing nodes with a local name' do
      evaluate_xpath(@document, 'root/b[local-name()]')
        .should == node_set(@document.children[0].children[1])
    end
  end
end
