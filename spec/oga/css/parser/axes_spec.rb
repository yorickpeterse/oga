require 'spec_helper'

describe Oga::CSS::Parser do
  context 'axes' do
    example 'parse the > axis' do
      parse_css('x > y').should == parse_xpath('descendant-or-self::x/y')
    end

    example 'parse the > axis called on another > axis' do
      parse_css('a > b > c').should == parse_xpath('descendant-or-self::a/b/c')
    end

    example 'parse an > axis followed by an element with an ID' do
      parse_css('x > foo#bar').should == parse_xpath(
        'descendant-or-self::x/foo[@id="bar"]'
      )
    end

    example 'parse an > axis followed by an element with a class' do
      parse_css('x > foo.bar').should == parse_xpath(
        'descendant-or-self::x/foo[contains(concat(" ", @class, " "), " bar ")]'
      )
    end

    example 'parse the + axis' do
      parse_css('x + y').should == parse_xpath(
        'descendant-or-self::x/following-sibling::*[1]/self::y'
      )
    end

    example 'parse the + axis called on another + axis' do
      parse_css('a + b + c').should == parse_xpath(
        'descendant-or-self::a/following-sibling::*[1]/self::b/' \
          'following-sibling::*[1]/self::c'
      )
    end

    example 'parse the ~ axis' do
      parse_css('x ~ y').should == parse_xpath(
        'descendant-or-self::x/following-sibling::y'
      )
    end

    example 'parse the ~ axis followed by another node test' do
      parse_css('x ~ y z').should == parse_xpath(
        'descendant-or-self::x/following-sibling::y/descendant-or-self::z'
      )
    end

    example 'parse the ~ axis called on another ~ axis' do
      parse_css('a ~ b ~ c').should == parse_xpath(
        'descendant-or-self::a/following-sibling::b/following-sibling::c'
      )
    end
  end
end
