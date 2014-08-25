require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'string-length() function' do
    before do
      @document  = parse('<root><a>x</a></root>')
      @evaluator = described_class.new(@document)
    end

    context 'outside predicates' do
      example 'return the length of a literal string' do
        @evaluator.evaluate('string-length("foo")').should == 3.0
      end

      example 'return the length of a literal integer' do
        @evaluator.evaluate('string-length(10)').should == 2.0
      end

      example 'return the length of a literal float' do
        # This includes the counting of the dot. That is, "10.5".length => 4
        @evaluator.evaluate('string-length(10.5)').should == 4.0
      end

      example 'return the length of a string in a node set' do
        @evaluator.evaluate('string-length(root)').should == 1.0
      end
    end

    context 'inside predicates' do
      before do
        # Since the length of <a> is 1 this should just return the <a> node.
        @set = @evaluator.evaluate('root/a[string-length()]')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <a> node' do
        @set[0].should == @document.children[0].children[0]
      end
    end
  end
end
