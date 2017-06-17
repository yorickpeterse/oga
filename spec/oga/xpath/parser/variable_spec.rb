require 'spec_helper'

describe Oga::XPath::Parser do
  describe 'variables' do
    it 'parses a variable reference' do
      expect(parse_xpath('$foo')).to eq(s(:var, 'foo'))
    end

    it 'parses a variable reference in a predicate' do
      expect(parse_xpath('foo[$bar]')).to eq(s(
        :predicate,
        s(:axis, 'child', s(:test, nil, 'foo')),
        s(:var, 'bar')
      ))
    end
  end
end
