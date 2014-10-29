require 'spec_helper'

describe Oga::CSS::Parser do
  context 'pseudo classes' do
    example 'parse the x:root pseudo class' do
      parse_css('x:root').should == parse_xpath(
        'descendant-or-self::x[not(parent::*)]'
      )
    end

    example 'parse the :root pseudo class' do
      parse_css(':root').should == parse_xpath(
        'descendant-or-self::*[not(parent::*)]'
      )
    end

    example 'parse the x:nth-child(1) pseudo class' do
      parse_css('x:nth-child(1)').should == parse_xpath(
        'descendant-or-self::x[count(preceding-sibling::*) = 0]'
      )
    end

    example 'parse the :nth-child(1) pseudo class' do
      parse_css(':nth-child(1)').should == parse_xpath(
        'descendant-or-self::*[count(preceding-sibling::*) = 0]'
      )
    end

    example 'parse the :nth-child(2) pseudo class' do
      parse_css(':nth-child(2)').should == parse_xpath(
        'descendant-or-self::*[count(preceding-sibling::*) = 1]'
      )
    end

    example 'parse the x:nth-child(even) pseudo class' do
      parse_css('x:nth-child(even)').should == parse_xpath(
        'descendant-or-self::x[((count(preceding-sibling::*) + 1) mod 2) = 0]'
      )
    end

    example 'parse the x:nth-child(odd) pseudo class' do
      parse_css('x:nth-child(odd)').should == parse_xpath(
        'descendant-or-self::x[(count(preceding-sibling::*) + 1) >= 1 ' \
          'and (((count(preceding-sibling::*) + 1) - 1) mod 2) = 0]'
      )
    end

    example 'parse the x:nth-child(n) pseudo class' do
      parse_css('x:nth-child(n)').should == parse_xpath(
        'descendant-or-self::x[((count(preceding-sibling::*) + 1) mod 1) = 0]'
      )
    end

    example 'parse the x:nth-child(-n) pseudo class' do
      parse_css('x:nth-child(-n)').should == parse_xpath(
        'descendant-or-self::x[((count(preceding-sibling::*) + 1) mod 1) = 0]'
      )
    end

    example 'parse the x:nth-child(2n) pseudo class' do
      parse_css('x:nth-child(2n)').should == s(
        :pseudo,
        s(:test, nil, 'x'),
        'nth-child',
        s(:nth, s(:int, 2))
      )
    end

    example 'parse the x:nth-child(2n+1) pseudo class' do
      parse_css('x:nth-child(2n+1)').should == s(
        :pseudo,
        s(:test, nil, 'x'),
        'nth-child',
        s(:nth, s(:int, 2), s(:int, 1))
      )
    end

    example 'parse the x:nth-child(2n-1) pseudo class' do
      parse_css('x:nth-child(2n-1)').should == s(
        :pseudo,
        s(:test, nil, 'x'),
        'nth-child',
        s(:nth, s(:int, 2), s(:int, -1))
      )
    end

    example 'parse the x:nth-child(-2n-1) pseudo class' do
      parse_css('x:nth-child(-2n-1)').should == s(
        :pseudo,
        s(:test, nil, 'x'),
        'nth-child',
        s(:nth, s(:int, -2), s(:int, -1))
      )
    end

    example 'parse two pseudo selectors' do
      parse_css('x:focus:hover').should == s(
        :pseudo,
        s(:pseudo, s(:test, nil, 'x'), 'focus'),
        'hover'
      )
    end

    example 'parse a pseudo class with an identifier as the argument' do
      parse_css('x:lang(fr)').should == s(
        :pseudo,
        s(:test, nil, 'x'),
        'lang',
        s(:test, nil, 'fr')
      )
    end
  end
end
