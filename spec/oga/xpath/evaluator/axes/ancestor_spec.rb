require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'ancestor axis' do
    before do
      @document  = parse('<a><b><c></c></b></a>')
      @c_node    = @document.children[0].children[0].children[0]
      @evaluator = described_class.new(@c_node)
    end

    context 'direct ancestors' do
      before do
        @set = @evaluator.evaluate('ancestor::b')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <b> ancestor' do
        @set[0].name.should == 'b'
      end
    end

    context 'higher ancestors' do
      before do
        @set = @evaluator.evaluate('ancestor::a')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <a> ancestor' do
        @set[0].name.should == 'a'
      end
    end

    context 'non existing ancestors' do
      before do
        @set = @evaluator.evaluate('ancestor::foobar')
      end

      it_behaves_like :empty_node_set
    end
  end
end
