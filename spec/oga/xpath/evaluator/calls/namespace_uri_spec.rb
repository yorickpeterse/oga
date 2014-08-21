require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'namespace-uri() function' do
    before do
      @document  = parse('<root xmlns:x="y"><x:a></x:a><b x:num="10"></b></root>')
      @evaluator = described_class.new(@document)
    end

    context 'outside predicates' do
      example 'return the namespace URI of the <x:a> node' do
        @evaluator.evaluate('namespace-uri(root/x:a)').should == 'y'
      end

      example 'return the namespace URI of the "num" attribute' do
        @evaluator.evaluate('namespace-uri(root/b/@x:num)').should == 'y'
      end

      example 'return an empty string when there is no namespace URI' do
        @evaluator.evaluate('namespace-uri(root/b)').should == ''
      end

      example 'raise TypeError for invalid argument types' do
        block = lambda { @evaluator.evaluate('namespace-uri("foo")') }

        block.should raise_error(TypeError)
      end
    end

    context 'inside predicates' do
      before do
        @set = @evaluator.evaluate('root/*[namespace-uri()]')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <x:a> node' do
        @set[0].should == @document.children[0].children[0]
      end
    end
  end
end
