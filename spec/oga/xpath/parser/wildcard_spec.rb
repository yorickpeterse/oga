require 'spec_helper'

describe Oga::XPath::Parser do
  describe 'wildcards' do
    it 'parses a wildcard name test' do
      expect(parse_xpath('*')).to eq(s(:axis, 'child', s(:test, nil, '*')))
    end

    it 'parses a wildcard namespace test' do
      expect(parse_xpath('*:A')).to eq(s(:axis, 'child', s(:test, '*', 'A')))
    end

    it 'parses a wildcard namespace and name test' do
      expect(parse_xpath('*:*')).to eq(s(:axis, 'child', s(:test, '*', '*')))
    end
  end
end
