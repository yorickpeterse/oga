require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'predicates' do
    before do
      @document  = parse('<root><a></a><b>10</b><b>20</b></root>')
      @evaluator = described_class.new(@document)
    end

    context 'using predicate indexes' do
      before do
        @set = @evaluator.evaluate('root/b[2]')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the second <b> node' do
        @set[0].should == @document.children[0].children[-1]
      end
    end
  end
end
