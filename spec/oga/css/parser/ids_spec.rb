require 'spec_helper'

describe Oga::CSS::Parser do
  context 'IDs' do
    example 'parse an ID selector' do
      parse_css('#foo').should == parse_xpath(
        'descendant-or-self::*[@id="foo"]'
      )
    end

    example 'parse a selector for an element with an ID' do
      parse_css('foo#bar').should == parse_xpath(
        'descendant-or-self::foo[@id="bar"]'
      )
    end

    example 'parse a selector using multiple IDs' do
      parse_css('#foo#bar').should == parse_xpath(
        'descendant-or-self::*[@id="foo" and @id="bar"]'
      )
    end

    example 'parse a selector using an ID and a class' do
      parse_css('.foo#bar').should == parse_xpath(
        'descendant-or-self::*[contains(concat(" ", @class, " "), " foo ") ' \
          'and @id="bar"]'
      )
    end
  end
end
