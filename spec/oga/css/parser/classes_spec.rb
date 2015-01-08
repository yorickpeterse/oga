require 'spec_helper'

describe Oga::CSS::Parser do
  describe 'classes' do
    it 'parses a class selector' do
      parse_css('.foo').should == parse_xpath(
        'descendant::*[contains(concat(" ", @class, " "), " foo ")]'
      )
    end

    it 'parses a selector for an element with a class' do
      parse_css('foo.bar').should == parse_xpath(
        'descendant::foo[contains(concat(" ", @class, " "), " bar ")]'
      )
    end

    it 'parses a selector using multiple classes' do
      parse_css('.foo.bar').should == parse_xpath(
        'descendant::*[contains(concat(" ", @class, " "), " foo ") ' \
          'and contains(concat(" ", @class, " "), " bar ")]'
      )
    end

    it 'parses a selector using a class and an ID' do
      parse_css('#foo.bar').should == parse_xpath(
        'descendant::*[@id="foo" and ' \
          'contains(concat(" ", @class, " "), " bar ")]'
      )
    end
  end
end
