require 'spec_helper'

describe Oga::CSS::Transformer do
  context 'classes' do
    before do
      @transformer = described_class.new
    end

    example 'convert a class node without a node test' do
      @transformer.process(parse_css('.y')).should == s(
        :axis,
        'child',
        s(
          :test,
          nil,
          '*',
          s(:eq, s(:axis, 'attribute', s(:test, nil, 'class')), s(:string, 'y'))
        )
      )
    end

    example 'convert a class node with a node test' do
      @transformer.process(parse_css('x.y')).should == s(
        :axis,
        'child',
        s(
          :test,
          nil,
          'x',
          s(:eq, s(:axis, 'attribute', s(:test, nil, 'class')), s(:string, 'y'))
        )
      )
    end
  end
end
