require 'spec_helper'

describe Oga::XML::PullParser do
  describe 'elements' do
    before :all do
      @parser = described_class.new('<person>Alice</person>')
    end

    it 'parses an element' do
      name = nil

      @parser.parse do |node|
        name = node.name if node.is_a?(Oga::XML::Element)
      end

      expect(name).to eq('person')
    end

    it 'parses the text of an element' do
      text = nil

      @parser.parse do |node|
        text = node.text if node.is_a?(Oga::XML::Text)
      end

      expect(text).to eq('Alice')
    end
  end
end
