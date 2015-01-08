require 'spec_helper'

describe Oga::XPath::Parser do
  describe 'variables' do
    it 'parses a variable reference' do
      parse_xpath('$foo').should == s(:var, 'foo')
    end

    it 'parses a variable reference in a predicate' do
      parse_xpath('foo[$bar]').should == s(
        :predicate,
        s(:axis, 'child', s(:test, nil, 'foo')),
        s(:var, 'bar')
      )
    end
  end
end
