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
  end
end
