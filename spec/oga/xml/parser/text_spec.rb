require 'spec_helper'

describe Oga::XML::Parser do
  describe 'plain text' do
    before :all do
      @node = parse('foo').children[0]
    end

    it 'returns a Text instance' do
      @node.is_a?(Oga::XML::Text).should == true
    end

    it 'sets the text' do
      @node.text.should == 'foo'
    end
  end
end
