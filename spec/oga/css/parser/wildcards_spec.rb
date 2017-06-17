require 'spec_helper'

describe Oga::CSS::Parser do
  describe 'wildcards' do
    it 'parses a wildcard name test' do
      expect(parse_css('*')).to eq(parse_xpath('descendant::*'))
    end

    it 'parses a wildcard namespace test' do
      expect(parse_css('*|foo')).to eq(parse_xpath('descendant::*:foo'))
    end

    it 'parses a wildcard namespace and name test' do
      expect(parse_css('*|*')).to eq(parse_xpath('descendant::*:*'))
    end
  end
end
