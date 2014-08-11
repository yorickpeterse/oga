require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'attribute axis' do
    before do
      document   = parse('<a foo="bar"></a>')
      @evaluator = described_class.new(document.children[0])
    end

    context 'matching existing attributes' do
      before do
        @set = @evaluator.evaluate('attribute::foo')
      end

      it_behaves_like :node_set, :length => 1

      example 'return an Attribute instance' do
        @set[0].is_a?(Oga::XML::Attribute).should == true
      end

      example 'return the "foo" attribute' do
        @set[0].name.should == 'foo'
      end
    end

    context 'matching non existing attributes' do
      before do
        @set = @evaluator.evaluate('attribute::bar')
      end

      it_behaves_like :empty_node_set
    end

    context 'matching attributes using the short form' do
      before do
        @set = @evaluator.evaluate('@foo')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the "foo" attribute' do
        @set[0].name.should == 'foo'
      end
    end
  end
end
