require 'spec_helper'

describe Oga::CSS::Parser do
  describe 'paths' do
    it 'parses a single path' do
      expect(parse_css('foo')).to eq(parse_xpath('descendant::foo'))
    end

    it 'parses a path using a namespace' do
      expect(parse_css('ns|foo')).to eq(parse_xpath('descendant::ns:foo'))
    end

    it 'parses a path using two selectors' do
      expect(parse_css('foo bar')).to eq(
        parse_xpath('descendant::foo/descendant::bar')
      )
    end

    it 'parses two paths separated by a comma' do
      expect(parse_css('foo, bar')).to eq(
        parse_xpath('descendant::foo | descendant::bar')
      )
    end

    it 'parses three paths separated by a comma' do
      expect(parse_css('foo, bar, baz')).to eq(
        parse_xpath('descendant::foo | descendant::bar | descendant::baz')
      )
    end
  end
end
