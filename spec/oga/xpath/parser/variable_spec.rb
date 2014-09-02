require 'spec_helper'

describe Oga::XPath::Parser do
  context 'variables' do
    example 'parse a variable reference' do
      parse_xpath('$foo').should == s(:var, 'foo')
    end

    example 'parse a variable reference in a predicate' do
      parse_xpath('foo[$bar]').should == s(
        :axis,
        'child',
        s(:test, nil, 'foo', s(:var, 'bar'))
      )
    end
  end
end
