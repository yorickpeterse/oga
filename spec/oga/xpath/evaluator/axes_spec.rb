require 'spec_helper'

describe Oga::XPath::Evaluator do
  before do
    @document = parse('<a><b><c></c></b><d></d></a>')
    @c_node   = @document.children[0].children[0].children[0]
  end

  context 'ancestor axis' do
    before do
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

      example 'return the <b> ancestor' do
        @set[0].name.should == 'a'
      end
    end
  end
end
