require 'spec_helper'

describe Oga::XML::Parser do
  describe 'plain text' do
    before :all do
      @node = parse('foo').children[0]
    end

    it 'returns a Text instance' do
      expect(@node.is_a?(Oga::XML::Text)).to eq(true)
    end

    it 'sets the text' do
      expect(@node.text).to eq('foo')
    end
  end
end
