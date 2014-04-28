require 'spec_helper'

describe Oga::XML::PullParser do
  context 'tracking element nesting' do
    before do
      @parser = described_class.new('<a><b></b></a>')
    end

    example 'set the nesting for the outer element' do
      @parser.parse do |node|
        @parser.nesting.should == %w{a} if node.name == 'a'

        @parser.nesting.should == %w{a b} if node.name == 'b'
      end
    end

    example 'pop element names after leaving an element' do
      @parser.nesting.should_receive(:pop).twice

      @parser.parse { |node| }
    end
  end
end
