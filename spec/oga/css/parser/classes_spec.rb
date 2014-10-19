require 'spec_helper'

describe Oga::CSS::Parser do
  context 'classes' do
    example 'parse a class selector' do
      parse_css('.foo').should == parse_xpath(
        'descendant-or-self::*[contains(concat(" ", @class, " "), "foo")]'
      )
    end

    example 'parse a selector for an element with a class' do
      parse_css('foo.bar').should == parse_xpath(
        'descendant-or-self::foo[contains(concat(" ", @class, " "), "bar")]'
      )
    end

    example 'parse a selector using multiple classes' do
      parse_css('.foo.bar').should == parse_xpath(
        'descendant-or-self::*[contains(concat(" ", @class, " "), "foo") ' \
          'and contains(concat(" ", @class, " "), "bar")]'
      )
    end

    example 'parse a selector using a class and an ID' do
      parse_css('#foo.bar').should == parse_xpath(
        'descendant-or-self::*[@id="foo" and ' \
          'contains(concat(" ", @class, " "), "bar")]'
      )
    end
  end
end
