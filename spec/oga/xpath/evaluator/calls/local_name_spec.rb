require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'local-name() function' do
    before do
      @document  = parse('<root xmlns:x="y"><x:a></x:a><b x:num="10"></b></root>')
      @evaluator = described_class.new(@document)
    end

    context 'outside predicates' do
      example 'return the local name of the <x:a> node' do
        @evaluator.evaluate('local-name(root/x:a)').should == 'a'
      end

      example 'return the local name of the <b> node' do
        @evaluator.evaluate('local-name(root/b)').should == 'b'
      end

      example 'return the local name for the "num" attribute' do
        @evaluator.evaluate('local-name(root/b/@x:num)').should == 'num'
      end

      example 'return only the name of the first node in the set' do
        @evaluator.evaluate('local-name(root/*)').should == 'a'
      end

      example 'return an empty string by default' do
        @evaluator.evaluate('local-name(foo)').should == ''
      end

      example 'raise a TypeError for invalid argument types' do
        block = lambda { @evaluator.evaluate('local-name("foo")') }

        block.should raise_error(TypeError)
      end
    end

    context 'inside predicates' do
      before do
        @set = @evaluator.evaluate('root/b[local-name()]')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <b> node' do
        @set[0].should == @document.children[0].children[1]
      end
    end
  end
end
