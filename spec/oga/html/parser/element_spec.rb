require 'spec_helper'

describe Oga::HTML::Parser do
  context 'HTML void elements' do
    before :all do
      @node = parse_html('<meta>').children[0]
    end

    example 'return an Element instance' do
      @node.is_a?(Oga::XML::Element).should == true
    end

    example 'set the name of the element' do
      @node.name.should == 'meta'
    end
  end
end
