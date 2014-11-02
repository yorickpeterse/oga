require 'spec_helper'

describe Oga::CSS::Parser do
  context ':nth-last-child pseudo class' do
    example 'parse the x:nth-last-child(1) pseudo class' do
      parse_css('x:nth-last-child(1)').should == parse_xpath(
        'descendant-or-self::x[count(following-sibling::*) = 0]'
      )
    end

    example 'parse the :nth-last-child(1) pseudo class' do
      parse_css(':nth-last-child(1)').should == parse_xpath(
        'descendant-or-self::*[count(following-sibling::*) = 0]'
      )
    end

    example 'parse the :nth-last-child(2) pseudo class' do
      parse_css(':nth-last-child(2)').should == parse_xpath(
        'descendant-or-self::*[count(following-sibling::*) = 1]'
      )
    end

    example 'parse the x:nth-last-child(even) pseudo class' do
      parse_css('x:nth-last-child(even)').should == parse_xpath(
        'descendant-or-self::x[((count(following-sibling::*) + 1) mod 2) = 0]'
      )
    end

    example 'parse the x:nth-last-child(odd) pseudo class' do
      parse_css('x:nth-last-child(odd)').should == parse_xpath(
        'descendant-or-self::x[(count(following-sibling::*) + 1) >= 1 ' \
          'and (((count(following-sibling::*) + 1) - 1) mod 2) = 0]'
      )
    end

    example 'parse the x:nth-last-child(n) pseudo class' do
      parse_css('x:nth-last-child(n)').should == parse_xpath(
        'descendant-or-self::x[((count(following-sibling::*) + 1) mod 1) = 0]'
      )
    end

    example 'parse the x:nth-last-child(-n) pseudo class' do
      parse_css('x:nth-last-child(-n)').should == parse_xpath(
        'descendant-or-self::x[((count(following-sibling::*) + 1) mod 1) = 0]'
      )
    end

    example 'parse the x:nth-last-child(-n+6) pseudo class' do
      parse_css('x:nth-last-child(-n+6)').should == parse_xpath(
        'descendant-or-self::x[((count(following-sibling::*) + 1) <= 6) ' \
          'and (((count(following-sibling::*) + 1) - 6) mod 1) = 0]'
      )
    end

    example 'parse the x:nth-last-child(2n) pseudo class' do
      parse_css('x:nth-last-child(2n)').should == parse_css(
        'x:nth-last-child(even)'
      )
    end

    example 'parse the x:nth-last-child(2n+1) pseudo class' do
      parse_css('x:nth-last-child(2n+1)').should == parse_xpath(
        'descendant-or-self::x[(count(following-sibling::*) + 1) >= 1 ' \
          'and (((count(following-sibling::*) + 1) - 1) mod 2) = 0]'
      )
    end

    example 'parse the x:nth-last-child(2n-6) pseudo class' do
      parse_css('x:nth-last-child(2n-6)').should == parse_xpath(
        'descendant-or-self::x[(count(following-sibling::*) + 1) >= 2 ' \
          'and (((count(following-sibling::*) + 1) - 2) mod 2) = 0]'
      )
    end

    example 'parse the x:nth-last-child(-2n-6) pseudo class' do
      parse_css('x:nth-last-child(-2n-6)').should == parse_xpath(
        'descendant-or-self::x[((count(following-sibling::*) + 1) <= -2) ' \
          'and (((count(following-sibling::*) + 1) - -2) mod 2) = 0]'
      )
    end

    example 'parse the x:nth-last-child(-2n+6) pseudo class' do
      parse_css('x:nth-last-child(-2n+6)').should == parse_xpath(
        'descendant-or-self::x[((count(following-sibling::*) + 1) <= 6) ' \
          'and (((count(following-sibling::*) + 1) - 6) mod 2) = 0]'
      )
    end
  end
end
