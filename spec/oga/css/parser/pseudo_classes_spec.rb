require 'spec_helper'

describe Oga::CSS::Parser do
  context 'pseudo classes' do
    example 'parse the :root pseudo class' do
      parse_css('x:root').should == s(:pseudo, 'root', s(:test, nil, 'x'))
    end

    example 'parse the x:nth-child pseudo class' do
      parse_css('x:nth-child(1)').should == s(
        :pseudo,
        'nth-child',
        s(:test, nil, 'x'),
        s(:int, 1)
      )
    end

    example 'parse the x:nth-child(odd) pseudo class' do
      parse_css('x:nth-child(odd)').should == s(
        :pseudo,
        'nth-child',
        s(:test, nil, 'x'),
        s(:odd)
      )
    end

    example 'parse the x:nth-child(even) pseudo class' do
      parse_css('x:nth-child(even)').should == s(
        :pseudo,
        'nth-child',
        s(:test, nil, 'x'),
        s(:even)
      )
    end

    example 'parse the x:nth-child(n) pseudo class' do
      parse_css('x:nth-child(n)').should == s(
        :pseudo,
        'nth-child',
        s(:test, nil, 'x'),
        s(:nth)
      )
    end

    example 'parse the x:nth-child(-n) pseudo class' do
      parse_css('x:nth-child(-n)').should == s(
        :pseudo,
        'nth-child',
        s(:test, nil, 'x'),
        s(:nth)
      )
    end

    example 'parse the x:nth-child(2n) pseudo class' do
      parse_css('x:nth-child(2n)').should == s(
        :pseudo,
        'nth-child',
        s(:test, nil, 'x'),
        s(:nth, s(:int, 2))
      )
    end

    example 'parse the x:nth-child(2n+1) pseudo class' do
      parse_css('x:nth-child(2n+1)').should == s(
        :pseudo,
        'nth-child',
        s(:test, nil, 'x'),
        s(:nth, s(:int, 2), s(:int, 1))
      )
    end

    example 'parse the x:nth-child(2n-1) pseudo class' do
      parse_css('x:nth-child(2n-1)').should == s(
        :pseudo,
        'nth-child',
        s(:test, nil, 'x'),
        s(:nth, s(:int, 2), s(:int, -1))
      )
    end

    example 'parse the x:nth-child(-2n-1) pseudo class' do
      parse_css('x:nth-child(-2n-1)').should == s(
        :pseudo,
        'nth-child',
        s(:test, nil, 'x'),
        s(:nth, s(:int, -2), s(:int, -1))
      )
    end

    example 'parse two pseudo selectors' do
      parse_css('x:focus:hover').should == s(
        :pseudo,
        'hover',
        s(:pseudo, 'focus', s(:test, nil, 'x'))
      )
    end
  end
end
