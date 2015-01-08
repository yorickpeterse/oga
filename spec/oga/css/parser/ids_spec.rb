require 'spec_helper'

describe Oga::CSS::Parser do
  describe 'IDs' do
    it 'parses an ID selector' do
      parse_css('#foo').should == parse_xpath('descendant::*[@id="foo"]')
    end

    it 'parses a selector for an element with an ID' do
      parse_css('foo#bar').should == parse_xpath('descendant::foo[@id="bar"]')
    end

    it 'parses a selector using multiple IDs' do
      parse_css('#foo#bar').should == parse_xpath(
        'descendant::*[@id="foo" and @id="bar"]'
      )
    end

    it 'parses a selector using an ID and a class' do
      parse_css('.foo#bar').should == parse_xpath(
        'descendant::*[contains(concat(" ", @class, " "), " foo ") ' \
          'and @id="bar"]'
      )
    end
  end
end
