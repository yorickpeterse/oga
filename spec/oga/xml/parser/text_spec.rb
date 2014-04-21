require 'spec_helper'

describe Oga::XML::Parser do
  context 'plain text' do
    before :all do
      @node = parse('foo').children[0]
    end

    example 'return a Text instance' do
      @node.is_a?(Oga::XML::Text).should == true
    end

    example 'set the text' do
      @node.text.should == 'foo'
    end
  end
end
