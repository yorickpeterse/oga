require 'spec_helper'

describe Oga::XML::Parser do
  describe 'elements with parents' do
    before :all do
      @parent = parse('<a><b></b></a>').children[0]
    end

    it 'returns an Element instance for the parent' do
      expect(@parent.children[0].parent.is_a?(Oga::XML::Element)).to eq(true)
    end

    it 'sets the correct parent' do
      expect(@parent.children[0].parent).to eq(@parent)
    end
  end

  describe 'text nodes with parents' do
    before :all do
      @parent = parse('<a>foo</a>').children[0]
    end

    it 'returns an Element instance for the parent' do
      expect(@parent.children[0].parent.is_a?(Oga::XML::Element)).to eq(true)
    end

    it 'sets the correct parent' do
      expect(@parent.children[0].parent).to eq(@parent)
    end
  end

  describe 'elements with adjacent elements' do
    before :all do
      @document = parse('<a></a><b></b>')
    end

    it 'returns an Element instance for the next element' do
      expect(@document.children[0].next.is_a?(Oga::XML::Element)).to eq(true)
    end

    it 'sets the correct next element' do
      expect(@document.children[0].next).to eq(@document.children[1])
    end

    it 'returns an Element instance for the previous element' do
      expect(@document.children[1].previous.is_a?(Oga::XML::Element)).to eq(true)
    end

    it 'sets the correct previous element' do
      expect(@document.children[1].previous).to eq(@document.children[0])
    end
  end
end
