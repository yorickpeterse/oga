require 'spec_helper'

describe Oga::CSS::Parser do
  describe 'classes' do
    it 'parses a class selector' do
      expect(parse_css('.foo')).to eq(parse_xpath(
        'descendant::*[contains(concat(" ", @class, " "), " foo ")]'
      ))
    end

    it 'parses a selector for an element with a class' do
      expect(parse_css('foo.bar')).to eq(parse_xpath(
        'descendant::foo[contains(concat(" ", @class, " "), " bar ")]'
      ))
    end

    it 'parses a selector using multiple classes' do
      expect(parse_css('.foo.bar')).to eq(parse_xpath(
        'descendant::*[contains(concat(" ", @class, " "), " foo ") ' \
          'and contains(concat(" ", @class, " "), " bar ")]'
      ))
    end

    it 'parses a selector using a class and an ID' do
      expect(parse_css('#foo.bar')).to eq(parse_xpath(
        'descendant::*[@id="foo" and ' \
          'contains(concat(" ", @class, " "), " bar ")]'
      ))
    end
  end
end
