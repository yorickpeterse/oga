require 'spec_helper'

describe Oga::XML::Parser do
  describe 'empty comments' do
    before :all do
      @node = parse('<!---->').children[0]
    end

    it 'returns a Comment instance' do
      expect(@node.is_a?(Oga::XML::Comment)).to eq(true)
    end
  end

  describe 'comments with text' do
    before :all do
      @node = parse('<!--foo-->').children[0]
    end

    it 'returns a Comment instance' do
      expect(@node.is_a?(Oga::XML::Comment)).to eq(true)
    end

    it 'sets the text of the comment' do
      expect(@node.text).to eq('foo')
    end
  end
end
