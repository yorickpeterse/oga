require 'spec_helper'

describe Oga::XPath::Evaluator do
  before do
    @document = parse('<a><b><c></c></b><d></d></a>')
  end

  context 'ancestor axis' do
    before do
      c_node     = @document.children[0].children[0].children[0]
      @evaluator = described_class.new(c_node)
    end

    context 'direct ancestors' do
      before do
        @set = @evaluator.evaluate('ancestor::b')
      end

      example 'return a NodeSet instance' do
        @set.is_a?(Oga::XML::NodeSet).should == true
      end

      example 'return the right amount of rows' do
        @set.length.should == 1
      end

      example 'return the <b> ancestor' do
        @set[0].name.should == 'b'
      end
    end

    context 'higher ancestors' do
      before do
        @set = @evaluator.evaluate('ancestor::a')
      end

      example 'return a NodeSet instance' do
        @set.is_a?(Oga::XML::NodeSet).should == true
      end

      example 'return the right amount of rows' do
        @set.length.should == 1
      end

      example 'return the <b> ancestor' do
        @set[0].name.should == 'a'
      end
    end
  end
end
