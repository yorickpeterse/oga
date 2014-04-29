require 'spec_helper'

describe Oga::XML::PullParser do
  context 'tracking nodes' do
    before :all do
      @parser = described_class.new('<a></a>')
    end

    example 'track the current node' do
      @parser.parse do
        @parser.node.is_a?(Oga::XML::Element).should == true
      end
    end

    example 'reset the current node after parsing' do
      @parser.parse { }

      @parser.node.nil?.should == true
    end
  end
end
