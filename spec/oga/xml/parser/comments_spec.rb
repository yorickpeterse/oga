require 'spec_helper'

describe Oga::XML::Parser do
  context 'empty comments' do
    before :all do
      @node = parse('<!---->').children[0]
    end

    example 'return a Comment instance' do
      @node.is_a?(Oga::XML::Comment).should == true
    end
  end

  context 'comments with text' do
    before :all do
      @node = parse('<!--foo-->').children[0]
    end

    example 'return a Comment instance' do
      @node.is_a?(Oga::XML::Comment).should == true
    end

    example 'set the text of the comment' do
      @node.text.should == 'foo'
    end
  end
end
