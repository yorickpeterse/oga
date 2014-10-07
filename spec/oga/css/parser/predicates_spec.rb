require 'spec_helper'

describe Oga::CSS::Parser do
  context 'predicates' do
    example 'parse a predicate' do
      parse_css('foo[bar]').should == s(:test, nil, 'foo', s(:test, nil, 'bar'))
    end

    example 'parse a node test followed by a node test with a predicate' do
      parse_css('foo bar[baz]').should == s(
        :path,
        s(:test, nil, 'foo'),
        s(:test, nil, 'bar', s(:test, nil, 'baz'))
      )
    end

    example 'parse a predicate testing an attribute value' do
      parse_css('foo[bar="baz"]').should == s(
        :test,
        nil,
        'foo',
        s(:eq, s(:test, nil, 'bar'), s(:string, 'baz'))
      )
    end
  end
end
