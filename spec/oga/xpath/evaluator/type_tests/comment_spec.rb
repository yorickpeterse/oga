require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'comment() tests' do
    before do
      @document  = parse('<a><!--foo--><b><!--bar--></b></a>')
      @evaluator = described_class.new(@document)
    end

    context 'matching comment nodes' do
      before do
        @set = @evaluator.evaluate('a/comment()')
      end

      it_behaves_like :node_set, :length => 1

      example 'return a Comment instance' do
        @set[0].is_a?(Oga::XML::Comment).should == true
      end

      example 'return the "foo" comment node' do
        @set[0].text.should == 'foo'
      end
    end

    context 'matching nested comment nodes' do
      before do
        @set = @evaluator.evaluate('a/b/comment()')
      end

      it_behaves_like :node_set, :length => 1

      example 'return a Comment instance' do
        @set[0].is_a?(Oga::XML::Comment).should == true
      end

      example 'return the "bar" comment node' do
        @set[0].text.should == 'bar'
      end
    end
  end
end
