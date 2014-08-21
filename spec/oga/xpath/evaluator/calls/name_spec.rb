require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'name() function' do
    before do
      @document  = parse('<root xmlns:x="y"><x:a></x:a><b x:num="10"></b></root>')
      @evaluator = described_class.new(@document)
    end

    context 'outside predicates' do
      example 'return the name of the <x:a> node' do
        @evaluator.evaluate('name(root/x:a)').should == 'x:a'
      end

      example 'return the name of the <b> node' do
        @evaluator.evaluate('name(root/b)').should == 'b'
      end

      example 'return the local name for the "num" attribute' do
        @evaluator.evaluate('name(root/b/@x:num)').should == 'x:num'
      end

      example 'return only the name of the first node in the set' do
        @evaluator.evaluate('name(root/*)').should == 'x:a'
      end

      example 'return an empty string by default' do
        @evaluator.evaluate('name(foo)').should == ''
      end

      example 'raise a TypeError for invalid argument types' do
        block = lambda { @evaluator.evaluate('name("foo")') }

        block.should raise_error(TypeError)
      end
    end

    context 'inside predicates' do
      before do
        @set = @evaluator.evaluate('root/b[name()]')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <b> node' do
        @set[0].should == @document.children[0].children[1]
      end
    end
  end
end
