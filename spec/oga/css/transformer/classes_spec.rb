require 'spec_helper'

describe Oga::CSS::Transformer do
  context 'classes' do
    example 'convert a class node without a node test' do
      transform_css('.y').should == parse_xpath('*[@class="y"]')
    end

    example 'convert a class node with a node test' do
      transform_css('x.y').should == parse_xpath('x[@class="y"]')
    end
  end
end
