require 'spec_helper'

describe Oga::CSS::Parser do
  describe 'predicates' do
    it 'parses a predicate' do
      expect(parse_css('foo[bar]')).to eq(parse_xpath('descendant::foo[@bar]'))
    end

    it 'parses a node test followed by a node test with a predicate' do
      expect(parse_css('foo bar[baz]')).to eq(parse_xpath(
        'descendant::foo/descendant::bar[@baz]'
      ))
    end

    it 'parses a predicate testing an attribute value' do
      expect(parse_css('foo[bar="baz"]')).to eq(parse_xpath(
        'descendant::foo[@bar="baz"]'
      ))
    end
  end
end
