require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'attribute axis' do
    before do
      document   = parse('<a foo="bar"><b x="y"></b></a>')
      @evaluator = described_class.new(document)
    end

    context 'top-level attributes' do
      before do
        @set = @evaluator.evaluate('attribute::foo')
      end

      it_behaves_like :node_set, :length => 1

      example 'return an Attribute instance' do
        @set[0].is_a?(Oga::XML::Attribute).should == true
      end

      example 'return the correct attribute' do
        @set[0].name.should == 'foo'
      end
    end

    context 'nested attributes' do
      before do
        @set = @evaluator.evaluate('/a/attribute::x')
      end

      it_behaves_like :node_set, :length => 1

      example 'return an Attribute instance' do
        @set[0].is_a?(Oga::XML::Attribute).should == true
      end

      example 'return the correct attribute' do
        @set[0].name.should == 'x'
      end
    end

    context 'non existing attributes' do
      before do
        @set = @evaluator.evaluate('attribute::bar')
      end

      it_behaves_like :empty_node_set
    end
  end
end
