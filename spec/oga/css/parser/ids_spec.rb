require 'spec_helper'

describe Oga::CSS::Parser do
  describe 'IDs' do
    it 'parses an ID selector' do
      expect(parse_css('#foo')).to eq(parse_xpath('descendant::*[@id="foo"]'))
    end

    it 'parses a selector for an element with an ID' do
      expect(parse_css('foo#bar')).to eq(parse_xpath('descendant::foo[@id="bar"]'))
    end

    it 'parses a selector using multiple IDs' do
      expect(parse_css('#foo#bar')).to eq(parse_xpath(
        'descendant::*[@id="foo" and @id="bar"]'
      ))
    end

    it 'parses a selector using an ID and a class' do
      expect(parse_css('.foo#bar')).to eq(parse_xpath(
        'descendant::*[contains(concat(" ", @class, " "), " foo ") ' \
          'and @id="bar"]'
      ))
    end
  end
end
