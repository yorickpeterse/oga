require 'spec_helper'

describe Oga::XML::PullParser do
  context '#on' do
    before do
      @parser = Oga::XML::PullParser.new('<a><b></b></a>')

      @parser.stub(:node).and_return(Oga::XML::Text.new)
    end

    example 'do not yield if the node types do not match' do
      expect { |b| @parser.on(:element, &b) }.to_not yield_control
    end

    example 'yield if the node type matches and the nesting is empty' do
      expect { |b| @parser.on(:text, &b) }.to yield_control
    end

    example 'do not yield if the node type matches but the nesting does not' do
      expect { |b| @parser.on(:text, %w{foo}, &b) }.to_not yield_control
    end

    example 'yield if the node type and the nesting matches' do
      @parser.stub(:nesting).and_return(%w{a b})

      expect { |b| @parser.on(:text, %w{a b}, &b) }.to yield_control
    end
  end
end
