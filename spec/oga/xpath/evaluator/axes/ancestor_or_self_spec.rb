require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'ancestor-or-self axis' do
    before do
      @document  = parse('<a><b><c></c></b></a>')
      @c_node    = @document.children[0].children[0].children[0]
      @evaluator = described_class.new(@c_node)
    end

    context 'direct ancestors' do
      before do
        @set = @evaluator.evaluate('ancestor-or-self::b')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <b> ancestor' do
        @set[0].name.should == 'b'
      end
    end

    context 'higher ancestors' do
      before do
        @set = @evaluator.evaluate('ancestor-or-self::a')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <a> ancestor' do
        @set[0].name.should == 'a'
      end
    end

    context 'ancestors that only match the context nodes' do
      before do
        @set = @evaluator.evaluate('ancestor-or-self::c')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <c> node' do
        @set[0].name.should == 'c'
      end
    end
  end
end
