require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'namespace-uri() function' do
    before do
      @document = parse('<root xmlns:x="y"><x:a></x:a><b x:num="10"></b></root>')
    end

    example 'return the namespace URI of the <x:a> node' do
      evaluate_xpath(@document, 'namespace-uri(root/x:a)').should == 'y'
    end

    example 'return the namespace URI of the "num" attribute' do
      evaluate_xpath(@document, 'namespace-uri(root/b/@x:num)').should == 'y'
    end

    example 'return an empty string when there is no namespace URI' do
      evaluate_xpath(@document, 'namespace-uri(root/b)').should == ''
    end

    example 'raise TypeError for invalid argument types' do
      block = -> { evaluate_xpath(@document, 'namespace-uri("foo")') }

      block.should raise_error(TypeError)
    end

    example 'return a node set containing nodes with a namespace URI' do
      evaluate_xpath(@document, 'root/*[namespace-uri()]')
        .should == node_set(@document.children[0].children[0])
    end
  end
end
