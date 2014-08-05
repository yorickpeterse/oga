require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'self axis' do
    before do
      @document  = parse('<a></a>')
      @evaluator = described_class.new(@document)
    end

    context 'matching the context node itself' do
      before do
        @set = @evaluator.evaluate('a/self::a')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <a> node' do
        @set[0].should == @document.children[0]
      end
    end

    context 'matching non existing nodes' do
      before do
        @set = @evaluator.evaluate('a/self::b')
      end

      it_behaves_like :empty_node_set
    end
  end
end
