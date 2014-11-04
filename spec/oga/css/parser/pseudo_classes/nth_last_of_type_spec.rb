require 'spec_helper'

describe Oga::CSS::Parser do
  context ':nth-last-of-type pseudo class' do
    example 'parse the :nth-last-of-type(1) pseudo class' do
      parse_css(':nth-last-of-type(1)').should == parse_xpath(
        'descendant::*[(last() - position() + 1) = 1]'
      )
    end

    example 'parse the :nth-last-of-type(2n) pseudo class' do
      parse_css(':nth-last-of-type(2n)').should == parse_xpath(
        'descendant::*[((last() - position() + 1) mod 2) = 0]'
      )
    end

    example 'parse the :nth-last-of-type(3n) pseudo class' do
      parse_css(':nth-last-of-type(3n)').should == parse_xpath(
        'descendant::*[((last() - position() + 1) mod 3) = 0]'
      )
    end

    example 'parse the :nth-last-of-type(2n+5) pseudo class' do
      parse_css(':nth-last-of-type(2n+5)').should == parse_xpath(
        'descendant::*[((last() - position() + 1) >= 5) ' \
          'and ((((last() - position() + 1) - 5) mod 2) = 0)]'
      )
    end

    example 'parse the :nth-last-of-type(3n+5) pseudo class' do
      parse_css(':nth-last-of-type(3n+5)').should == parse_xpath(
        'descendant::*[((last() - position() + 1) >= 5) ' \
          'and ((((last() - position() + 1) - 5) mod 3) = 0)]'
      )
    end

    example 'parse the :nth-last-of-type(2n-5) pseudo class' do
      parse_css(':nth-last-of-type(2n-5)').should == parse_xpath(
        'descendant::*[((last() - position() + 1) >= 1) ' \
          'and ((((last() - position() + 1) - 1) mod 2) = 0)]'
      )
    end

    example 'parse the :nth-last-of-type(2n-6) pseudo class' do
      parse_css(':nth-last-of-type(2n-6)').should == parse_xpath(
        'descendant::*[((last() - position() + 1) >= 2) ' \
          'and ((((last() - position() + 1) - 2) mod 2) = 0)]'
      )
    end

    example 'parse the :nth-last-of-type(-2n+5) pseudo class' do
      parse_css(':nth-last-of-type(-2n+5)').should == parse_xpath(
        'descendant::*[((last() - position() + 1) <= 5) ' \
          'and (((last() - position() + 1) - 5) mod 2) = 0]'
      )
    end

    example 'parse the :nth-last-of-type(-2n-5) pseudo class' do
      parse_css(':nth-last-of-type(-2n-5)').should == parse_xpath(
        'descendant::*[((last() - position() + 1) <= -1) ' \
          'and (((last() - position() + 1) - -1) mod 2) = 0]'
      )
    end

    example 'parse the :nth-last-of-type(-2n-6) pseudo class' do
      parse_css(':nth-last-of-type(-2n-6)').should == parse_xpath(
        'descendant::*[((last() - position() + 1) <= -2) ' \
          'and (((last() - position() + 1) - -2) mod 2) = 0]'
      )
    end

    example 'parse the :nth-last-of-type(even) pseudo class' do
      parse_css(':nth-last-of-type(even)').should == parse_xpath(
        'descendant::*[((last() - position() + 1) mod 2) = 0]'
      )
    end

    example 'parse the :nth-last-of-type(odd) pseudo class' do
      parse_css(':nth-last-of-type(odd)').should == parse_xpath(
        'descendant::*[((last() - position() + 1) >= 1) ' \
          'and ((((last() - position() + 1) - 1) mod 2) = 0)]'
      )
    end

    example 'parse the :nth-last-of-type(n) pseudo class' do
      parse_css(':nth-last-of-type(n)').should == parse_xpath(
        'descendant::*[((last() - position() + 1) mod 1) = 0]'
      )
    end

    example 'parse the :nth-last-of-type(n+5) pseudo class' do
      parse_css(':nth-last-of-type(n+5)').should == parse_xpath(
        'descendant::*[(last() - position() + 1) >= 5 ' \
          'and (((last() - position() + 1) - 5) mod 1) = 0]'
      )
    end

    example 'parse the :nth-last-of-type(-n) pseudo class' do
      parse_css(':nth-last-of-type(-n)').should == parse_xpath(
        'descendant::*[((last() - position() + 1) mod 1) = 0]'
      )
    end

    example 'parse the :nth-last-of-type(-n+5) pseudo class' do
      parse_css(':nth-last-of-type(-n+5)').should == parse_xpath(
        'descendant::*[((last() - position() + 1) <= 5) ' \
          'and (((last() - position() + 1) - 5) mod 1) = 0]'
      )
    end
  end
end
