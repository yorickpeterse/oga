require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'name() function' do
    before do
      @document = parse('<root xmlns:x="y"><x:a></x:a><b x:num="10"></b></root>')
    end

    example 'return the name of the <x:a> node' do
      evaluate_xpath(@document, 'name(root/x:a)').should == 'x:a'
    end

    example 'return the name of the <b> node' do
      evaluate_xpath(@document, 'name(root/b)').should == 'b'
    end

    example 'return the local name for the "num" attribute' do
      evaluate_xpath(@document, 'name(root/b/@x:num)').should == 'x:num'
    end

    example 'return only the name of the first node in the set' do
      evaluate_xpath(@document, 'name(root/*)').should == 'x:a'
    end

    example 'return an empty string by default' do
      evaluate_xpath(@document, 'name(foo)').should == ''
    end

    example 'raise a TypeError for invalid argument types' do
      block = -> { evaluate_xpath(@document, 'name("foo")') }

      block.should raise_error(TypeError)
    end

    example 'return a node set containing nodes with a name' do
      evaluate_xpath(@document, 'root/b[name()]')
        .should == node_set(@document.children[0].children[1])
    end
  end
end
