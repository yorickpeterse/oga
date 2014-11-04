require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'self axis' do
    before do
      @document  = parse('<a><b>foo</b><b>bar<c>test</c></b></a>')
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

    context 'matching the context node itself using the short form' do
      before do
        @set = @evaluator.evaluate('a/.')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <a> node' do
        @set[0].should == @document.children[0]
      end
    end

    context 'matching nodes inside predicates' do
      before do
        @set = @evaluator.evaluate('a/b[. = "foo"]')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the first <b> node' do
        @set[0].should == @document.children[0].children[0]
      end
    end

    context 'using self inside a path inside a predicate' do
      before do
        @set = @evaluator.evaluate('a/b[c/. = "test"]')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the second <b> node' do
        @set[0].should == @document.children[0].children[1]
      end
    end

    context 'using self inside a nested predicate' do
      before do
        @set = @evaluator.evaluate('a/b[c[. = "test"]]')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the second <b> node' do
        @set[0].should == @document.children[0].children[1]
      end
    end

    context 'matching the document itself' do
      before do
        @set = @evaluator.evaluate('self::node()')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the document itself' do
        @set[0].is_a?(Oga::XML::Document).should == true
      end
    end
  end
end
