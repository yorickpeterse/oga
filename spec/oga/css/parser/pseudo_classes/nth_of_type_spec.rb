require 'spec_helper'

describe Oga::CSS::Parser do
  context ':nth-of-type pseudo class' do
    example 'parse the x:nth-of-type(1) pseudo class' do
      parse_css('x:nth-of-type(1)').should == parse_xpath(
        'descendant::x[count(preceding-sibling::x) = 0]'
      )
    end

    example 'parse the :nth-of-type(1) pseudo class' do
      parse_css(':nth-of-type(1)').should == parse_xpath(
        'descendant::*[count(preceding-sibling::*) = 0]'
      )
    end

    example 'parse the :nth-of-type(2) pseudo class' do
      parse_css(':nth-of-type(2)').should == parse_xpath(
        'descendant::*[count(preceding-sibling::*) = 1]'
      )
    end

    example 'parse the x:nth-of-type(even) pseudo class' do
      parse_css('x:nth-of-type(even)').should == parse_xpath(
        'descendant::x[((count(preceding-sibling::x) + 1) mod 2) = 0]'
      )
    end

    example 'parse the x:nth-of-type(odd) pseudo class' do
      parse_css('x:nth-of-type(odd)').should == parse_xpath(
        'descendant::x[(count(preceding-sibling::x) + 1) >= 1 ' \
          'and (((count(preceding-sibling::x) + 1) - 1) mod 2) = 0]'
      )
    end

    example 'parse the x:nth-of-type(n) pseudo class' do
      parse_css('x:nth-of-type(n)').should == parse_xpath(
        'descendant::x[((count(preceding-sibling::x) + 1) mod 1) = 0]'
      )
    end

    example 'parse the x:nth-of-type(-n) pseudo class' do
      parse_css('x:nth-of-type(-n)').should == parse_xpath(
        'descendant::x[((count(preceding-sibling::x) + 1) mod 1) = 0]'
      )
    end

    example 'parse the x:nth-of-type(-n+6) pseudo class' do
      parse_css('x:nth-of-type(-n+6)').should == parse_xpath(
        'descendant::x[((count(preceding-sibling::x) + 1) <= 6) ' \
          'and (((count(preceding-sibling::x) + 1) - 6) mod 1) = 0]'
      )
    end

    example 'parse the x:nth-of-type(n+5) pseudo class' do
      parse_css('x:nth-of-type(n+5)').should == parse_xpath(
        'descendant::x[(count(preceding-sibling::x) + 1) >= 5 ' \
          'and (((count(preceding-sibling::x) + 1) - 5) mod 1) = 0]'
      )
    end

    example 'parse the x:nth-of-type(2n) pseudo class' do
      parse_css('x:nth-of-type(2n)').should == parse_css('x:nth-of-type(even)')
    end

    example 'parse the x:nth-of-type(2n+1) pseudo class' do
      parse_css('x:nth-of-type(2n+1)').should == parse_xpath(
        'descendant::x[(count(preceding-sibling::x) + 1) >= 1 ' \
          'and (((count(preceding-sibling::x) + 1) - 1) mod 2) = 0]'
      )
    end

    example 'parse the x:nth-of-type(3n+1) pseudo class' do
      parse_css('x:nth-of-type(3n+1)').should == parse_xpath(
        'descendant::x[(count(preceding-sibling::x) + 1) >= 1 ' \
          'and (((count(preceding-sibling::x) + 1) - 1) mod 3) = 0]'
      )
    end

    example 'parse the x:nth-of-type(2n-6) pseudo class' do
      parse_css('x:nth-of-type(2n-6)').should == parse_xpath(
        'descendant::x[(count(preceding-sibling::x) + 1) >= 2 ' \
          'and (((count(preceding-sibling::x) + 1) - 2) mod 2) = 0]'
      )
    end

    example 'parse the x:nth-of-type(-2n+6) pseudo class' do
      parse_css('x:nth-of-type(-2n+6)').should == parse_xpath(
        'descendant::x[((count(preceding-sibling::x) + 1) <= 6) ' \
          'and (((count(preceding-sibling::x) + 1) - 6) mod 2) = 0]'
      )
    end
  end
end
