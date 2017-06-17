require 'spec_helper'

describe Oga::HTML::Parser do
  describe 'HTML void elements' do
    before :all do
      @node = parse_html('<meta>').children[0]
    end

    it 'returns an Element instance' do
      expect(@node.is_a?(Oga::XML::Element)).to eq(true)
    end

    it 'sets the name of the element' do
      expect(@node.name).to eq('meta')
    end
  end
end
