require 'spec_helper'

describe Oga::CSS::Parser do
  context ':nth-of-type pseudo class' do
    example 'parse the :nth-of-type(1) pseudo class' do
      parse_css(':nth-of-type(1)').should == parse_xpath(
        'descendant-or-self::*[position() = 1]'
      )
    end

    example 'parse the :nth-of-type(2n) pseudo class' do
      parse_css(':nth-of-type(2n)').should == parse_xpath(
        'descendant-or-self::*[(position() mod 2) = 0]'
      )
    end

    example 'parse the :nth-of-type(3n) pseudo class' do
      parse_css(':nth-of-type(3n)').should == parse_xpath(
        'descendant-or-self::*[(position() mod 3) = 0]'
      )
    end

    example 'parse the :nth-of-type(2n+5) pseudo class' do
      parse_css(':nth-of-type(2n+5)').should == parse_xpath(
        'descendant-or-self::*[(position() >= 5) ' \
          'and (((position() - 5) mod 2) = 0)]'
      )
    end

    example 'parse the :nth-of-type(3n+5) pseudo class' do
      parse_css(':nth-of-type(3n+5)').should == parse_xpath(
        'descendant-or-self::*[(position() >= 5) ' \
          'and (((position() - 5) mod 3) = 0)]'
      )
    end

    example 'parse the :nth-of-type(2n-5) pseudo class' do
      parse_css(':nth-of-type(2n-5)').should == parse_xpath(
        'descendant-or-self::*[(position() >= 1) ' \
          'and (((position() - 1) mod 2) = 0)]'
      )
    end

    example 'parse the :nth-of-type(2n-6) pseudo class' do
      parse_css(':nth-of-type(2n-6)').should == parse_xpath(
        'descendant-or-self::*[(position() >= 2) ' \
          'and (((position() - 2) mod 2) = 0)]'
      )
    end

    example 'parse the :nth-of-type(-2n+5) pseudo class' do
      parse_css(':nth-of-type(-2n+5)').should == parse_xpath(
        'descendant-or-self::*[(position() <= 5) ' \
          'and ((position() - 5) mod 2) = 0]'
      )
    end

    example 'parse the :nth-of-type(-2n-5) pseudo class' do
      parse_css(':nth-of-type(-2n-5)').should == parse_xpath(
        'descendant-or-self::*[(position() <= -1) ' \
          'and ((position() - -1) mod 2) = 0]'
      )
    end

    example 'parse the :nth-of-type(-2n-6) pseudo class' do
      parse_css(':nth-of-type(-2n-6)').should == parse_xpath(
        'descendant-or-self::*[(position() <= -2) ' \
          'and ((position() - -2) mod 2) = 0]'
      )
    end

    example 'parse the :nth-of-type(even) pseudo class' do
      parse_css(':nth-of-type(even)').should == parse_xpath(
        'descendant-or-self::*[(position() mod 2) = 0]'
      )
    end

    example 'parse the :nth-of-type(odd) pseudo class' do
      parse_css(':nth-of-type(odd)').should == parse_xpath(
        'descendant-or-self::*[(position() >= 1) ' \
          'and (((position() - 1) mod 2) = 0)]'
      )
    end

    example 'parse the :nth-of-type(n) pseudo class' do
      parse_css(':nth-of-type(n)').should == parse_xpath(
        'descendant-or-self::*[(position() mod 1) =0]'
      )
    end

    example 'parse the :nth-of-type(n+5) pseudo class' do
      parse_css(':nth-of-type(n+5)').should == parse_xpath(
        'descendant-or-self::*[position() >= 5 ' \
          'and ((position() - 5) mod 1) = 0]'
      )
    end

    example 'parse the :nth-of-type(-n) pseudo class' do
      parse_css(':nth-of-type(-n)').should == parse_xpath(
        'descendant-or-self::*[(position() mod 1) = 0]'
      )
    end

    example 'parse the :nth-of-type(-n+5) pseudo class' do
      parse_css(':nth-of-type(-n+5)').should == parse_xpath(
        'descendant-or-self::*[(position() <= 5) ' \
          'and ((position() - 5) mod 1) = 0]'
      )
    end
  end
end
