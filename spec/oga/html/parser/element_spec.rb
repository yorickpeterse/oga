require 'spec_helper'

describe Oga::HTML::Parser do
  describe 'HTML void elements' do
    before :all do
      @node = parse_html('<meta>').children[0]
    end

    it 'returns an Element instance' do
      @node.is_a?(Oga::XML::Element).should == true
    end

    it 'sets the name of the element' do
      @node.name.should == 'meta'
    end
  end
end
