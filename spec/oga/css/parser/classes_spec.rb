require 'spec_helper'

describe Oga::CSS::Parser do
  context 'classes' do
    example 'parse a class selector' do
      parse_css('.foo').should == parse_xpath(
        'descendant-or-self::*[@class="foo"]'
      )
    end

    example 'parse a selector for an element with a class' do
      parse_css('foo.bar').should == parse_xpath(
        'descendant-or-self::foo[@class="bar"]'
      )
    end

    example 'parse a selector using multiple classes' do
      parse_css('.foo.bar').should == parse_xpath(
        'descendant-or-self::*[@class="foo" and @class="bar"]'
      )
    end

    example 'parse a selector using a class and an ID' do
      parse_css('#foo.bar').should == parse_xpath(
        'descendant-or-self::*[@id="foo" and @class="bar"]'
      )
    end
  end
end
