require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'parent axis' do
    before do
      @document  = parse('<a><b></b></a>')
      @evaluator = described_class.new(@document)
    end

    context 'matching nodes without parents' do
      before do
        @set = @evaluator.evaluate('parent::a')
      end

      it_behaves_like :empty_node_set
    end

    context 'matching nodes with parents' do
      before do
        @set = @evaluator.evaluate('a/b/parent::a')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <a> node' do
        @set[0].should == @document.children[0]
      end
    end

    context 'matching nodes with parents using the short axis form' do
      before do
        @set = @evaluator.evaluate('a/b/parent::node()')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <a> node' do
        @set[0].should == @document.children[0]
      end
    end
  end
end
