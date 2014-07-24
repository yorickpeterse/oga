require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'child axis' do
    before do
      @document  = parse('<a><b></b></a>')
      @evaluator = described_class.new(@document)
    end

    context 'direct children' do
      before do
        @set = @evaluator.evaluate('child::a')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <a> node' do
        @set[0].name.should == 'a'
      end
    end

    context 'nested children' do
      before do
        @set = @evaluator.evaluate('child::a/child::b')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <b> node' do
        @set[0].name.should == 'b'
      end
    end

    context 'non existing children' do
      before do
        @set = @evaluator.evaluate('child::b')
      end

      it_behaves_like :empty_node_set
    end
  end
end
