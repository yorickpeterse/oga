require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'text() tests' do
    before do
      @document  = parse('<a>foo<b>bar</b></a>')
      @evaluator = described_class.new(@document)
    end

    context 'matching text nodes' do
      before do
        @set = @evaluator.evaluate('a/text()')
      end

      it_behaves_like :node_set, :length => 1

      example 'return a Text instance' do
        @set[0].is_a?(Oga::XML::Text).should == true
      end

      example 'return the "foo" text node' do
        @set[0].text.should == 'foo'
      end
    end

    context 'matching nested text nodes' do
      before do
        @set = @evaluator.evaluate('a/b/text()')
      end

      it_behaves_like :node_set, :length => 1

      example 'return a Text instance' do
        @set[0].is_a?(Oga::XML::Text).should == true
      end

      example 'return the "bar" text node' do
        @set[0].text.should == 'bar'
      end
    end
  end
end
