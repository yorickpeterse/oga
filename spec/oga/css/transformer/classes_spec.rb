require 'spec_helper'

describe Oga::CSS::Transformer do
  context 'classes' do
    before do
      @transformer = described_class.new
    end

    example 'convert a class node without a node test' do
      @transformer.process(parse_css('.foo')).should == s(
        :axis,
        'child',
        s(
          :test,
          nil,
          '*',
          s(:eq, s(:axis, 'attribute', s(:test, nil, 'class')), s(:string, 'foo'))
        )
      )
    end

    example 'convert a class node with a node test' do
      @transformer.process(parse_css('x.foo')).should == s(
        :axis,
        'child',
        s(
          :test,
          nil,
          'x',
          s(:eq, s(:axis, 'attribute', s(:test, nil, 'class')), s(:string, 'foo'))
        )
      )
    end
  end
end
