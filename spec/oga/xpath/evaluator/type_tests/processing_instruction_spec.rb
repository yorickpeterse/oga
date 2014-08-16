require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'processing-instruction() tests' do
    before do
      @document  = parse('<a><?a foo ?><b><?b bar ?></b></a>')
      @evaluator = described_class.new(@document)
    end

    context 'matching processing instruction nodes' do
      before do
        @set = @evaluator.evaluate('a/processing-instruction()')
      end

      it_behaves_like :node_set, :length => 1

      example 'return a ProcessingInstruction instance' do
        @set[0].is_a?(Oga::XML::ProcessingInstruction).should == true
      end

      example 'return the "foo" node' do
        @set[0].text.should == ' foo '
      end
    end

    context 'matching nested processing instruction nodes' do
      before do
        @set = @evaluator.evaluate('a/b/processing-instruction()')
      end

      it_behaves_like :node_set, :length => 1

      example 'return a ProcessingInstruction instance' do
        @set[0].is_a?(Oga::XML::ProcessingInstruction).should == true
      end

      example 'return the "bar" node' do
        @set[0].text.should == ' bar '
      end
    end
  end
end
