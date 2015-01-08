require 'spec_helper'

describe Oga::CSS::Parser do
  describe 'axes' do
    it 'parses the > axis' do
      parse_css('x > y').should == parse_xpath('descendant::x/y')
    end

    it 'parses the > axis called on another > axis' do
      parse_css('a > b > c').should == parse_xpath('descendant::a/b/c')
    end

    it 'parses an > axis followed by an element with an ID' do
      parse_css('x > foo#bar').should == parse_xpath(
        'descendant::x/foo[@id="bar"]'
      )
    end

    it 'parses an > axis followed by an element with a class' do
      parse_css('x > foo.bar').should == parse_xpath(
        'descendant::x/foo[contains(concat(" ", @class, " "), " bar ")]'
      )
    end

    it 'parses the + axis' do
      parse_css('x + y').should == parse_xpath(
        'descendant::x/following-sibling::*[1]/self::y'
      )
    end

    it 'parses the + axis called on another + axis' do
      parse_css('a + b + c').should == parse_xpath(
        'descendant::a/following-sibling::*[1]/self::b/' \
          'following-sibling::*[1]/self::c'
      )
    end

    it 'parses the ~ axis' do
      parse_css('x ~ y').should == parse_xpath(
        'descendant::x/following-sibling::y'
      )
    end

    it 'parses the ~ axis followed by another node test' do
      parse_css('x ~ y z').should == parse_xpath(
        'descendant::x/following-sibling::y/descendant::z'
      )
    end

    it 'parses the ~ axis called on another ~ axis' do
      parse_css('a ~ b ~ c').should == parse_xpath(
        'descendant::a/following-sibling::b/following-sibling::c'
      )
    end
  end
end
