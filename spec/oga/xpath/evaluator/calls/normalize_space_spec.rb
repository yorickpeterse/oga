require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'normalize-space() function' do
    before do
      @document  = parse('<root><a> fo   o </a></root>')
      @evaluator = described_class.new(@document)
    end

    context 'outside predicates' do
      example 'normalize a literal string' do
        @evaluator.evaluate('normalize-space(" fo  o ")').should == 'fo o'
      end

      example 'normalize a string in a node set' do
        @evaluator.evaluate('normalize-space(root/a)').should == 'fo o'
      end

      example 'normalize an integer' do
        @evaluator.evaluate('normalize-space(10)').should == '10'
      end

      example 'normalize a float' do
        @evaluator.evaluate('normalize-space(10.5)').should == '10.5'
      end
    end

    context 'inside predicates' do
      before do
        @set = @evaluator.evaluate('root/a[normalize-space()]')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <a> node' do
        @set[0].should == @document.children[0].children[0]
      end
    end
  end
end
