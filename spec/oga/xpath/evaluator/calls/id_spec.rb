require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'id() function' do
    before do
      @document  = parse('<root id="r1"><a id="a1"></a><a id="a2">a1</a></root>')
      @first_a   = @document.children[0].children[0]
      @second_a  = @document.children[0].children[1]
      @evaluator = described_class.new(@document)
    end

    context 'using a single string ID' do
      before do
        @set = @evaluator.evaluate('id("a1")')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the first <a> node' do
        @set[0].should == @first_a
      end
    end

    context 'using multiple string IDs' do
      before do
        @set = @evaluator.evaluate('id("a1 a2")')
      end

      it_behaves_like :node_set, :length => 2

      example 'return the first <a> node' do
        @set[0].should == @first_a
      end

      example 'return the second <a> node' do
        @set[1].should == @second_a
      end
    end

    context 'using a node set' do
      before do
        @set = @evaluator.evaluate('id(root/a[2])')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the first <a> node' do
        @set[0].should == @first_a
      end
    end
  end
end
