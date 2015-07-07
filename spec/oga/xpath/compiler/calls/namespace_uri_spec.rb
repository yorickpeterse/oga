require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'namespace-uri() function' do
    before do
      @document = parse('<root xmlns:x="y"><x:a></x:a><b x:num="10"></b></root>')
    end

    it 'returns the namespace URI of the <x:a> node' do
      evaluate_xpath(@document, 'namespace-uri(root/x:a)').should == 'y'
    end

    it 'returns the namespace URI of the "num" attribute' do
      evaluate_xpath(@document, 'namespace-uri(root/b/@x:num)').should == 'y'
    end

    it 'returns an empty string when there is no namespace URI' do
      evaluate_xpath(@document, 'namespace-uri(root/b)').should == ''
    end

    it 'raises TypeError for invalid argument types' do
      block = -> { evaluate_xpath(@document, 'namespace-uri("foo")') }

      block.should raise_error(TypeError)
    end

    it 'returns a node set containing nodes with a namespace URI' do
      evaluate_xpath(@document, 'root/*[namespace-uri()]')
        .should == node_set(@document.children[0].children[0])
    end
  end
end
