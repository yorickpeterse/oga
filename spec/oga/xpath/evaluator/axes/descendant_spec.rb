require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'descendant axis' do
    before do
      @document  = parse('<a><b><c></c></b><a></a></a>')
      @evaluator = described_class.new(@document)

      @first_a  = @document.children[0]
      @second_a = @first_a.children[-1]
    end

    context 'direct descendants' do
      before do
        @set = @evaluator.evaluate('descendant::a')
      end

      it_behaves_like :node_set, :length => 2

      example 'return the first <a> node' do
        @set[0].should == @first_a
      end

      example 'return the second <a> node' do
        @set[1].should == @second_a
      end
    end

    context 'nested descendants' do
      before do
        @set = @evaluator.evaluate('descendant::c')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <c> node' do
        @set[0].name.should == 'c'
      end
    end

    context 'descendants of a specific node' do
      before do
        @set = @evaluator.evaluate('a/descendant::a')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the second <a> node' do
        @set[0].should == @second_a
      end
    end

    context 'non existing descendants' do
      before do
        @set = @evaluator.evaluate('descendant::foobar')
      end

      it_behaves_like :empty_node_set
    end
  end
end
