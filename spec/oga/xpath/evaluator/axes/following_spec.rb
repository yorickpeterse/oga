require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'following axis' do
    before do
      document   = parse('<a><b></b><c></c><c></c></a>')

      @first_c   = document.children[0].children[1]
      @second_c  = document.children[0].children[2]
      @evaluator = described_class.new(document)
    end

    # This should return an empty set since the document doesn't have any
    # following nodes.
    context 'using a document as the root' do
      before do
        @set = @evaluator.evaluate('following::a')
      end

      it_behaves_like :empty_node_set
    end

    context 'matching following elements using a name' do
      before do
        @set = @evaluator.evaluate('a/b/following::c')
      end

      it_behaves_like :node_set, :length => 2

      example 'return the first <c> node' do
        @set[0].should == @first_c
      end

      example 'return the second <c> node' do
        @set[1].should == @second_c
      end
    end

    context 'matching following elements using a wildcard' do
      before do
        @set = @evaluator.evaluate('a/b/following::*')
      end

      it_behaves_like :node_set, :length => 2
    end
  end
end
