require 'spec_helper'

describe Oga::XPath::Parser do
  context 'predicates' do
    example 'parse a single predicate' do
      parse_xpath('foo[@class="bar"]').should == s(
        :axis,
        'child',
        s(
          :test,
          nil,
          'foo',
          s(:eq, s(:axis, 'attribute', s(:test, nil, 'class')), s(:string, 'bar'))
        )
      )
    end

    example 'parse a predicate using the or operator' do
      parse_xpath('foo[@x="bar" or @x="baz"]').should == s(
        :axis,
        'child',
        s(
          :test,
          nil,
          'foo',
          s(
            :or,
            s(:eq, s(:axis, 'attribute', s(:test, nil, 'x')), s(:string, 'bar')),
            s(:eq, s(:axis, 'attribute', s(:test, nil, 'x')), s(:string, 'baz')),
          )
        )
      )
    end
  end
end
