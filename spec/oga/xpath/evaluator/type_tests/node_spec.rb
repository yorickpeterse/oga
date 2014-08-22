require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'node() tests' do
    before do
      @document  = parse('<a><b>foo</b><!--foo--><![CDATA[bar]]></a>')
      @evaluator = described_class.new(@document)
    end

    context 'matching elements' do
      before do
        @set = @evaluator.evaluate('node()')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <a> node' do
        @set[0].name.should == 'a'
      end
    end

    context 'matching nested elements' do
      before do
        @set = @evaluator.evaluate('a/node()')
      end

      it_behaves_like :node_set, :length => 3

      example 'return the <b> node' do
        @set[0].name.should == 'b'
      end

      example 'return the "foo" comment' do
        @set[1].text.should == 'foo'
      end

      example 'return the "bar" CDATA tag' do
        @set[2].text.should == 'bar'
      end
    end

    context 'matching text nodes' do
      before do
        @set = @evaluator.evaluate('a/b/node()')
      end

      it_behaves_like :node_set, :length => 1

      example 'return a Text instance' do
        @set[0].is_a?(Oga::XML::Text).should == true
      end

      example 'include the text' do
        @set[0].text.should == 'foo'
      end
    end
  end
end
