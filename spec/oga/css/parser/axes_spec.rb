require 'spec_helper'

describe Oga::CSS::Parser do
  context 'axes' do
    example 'parse the > axis' do
      parse_css('x > y').should == s(
        :axis,
        'child',
        s(:test, nil, 'x'),
        s(:test, nil, 'y')
      )
    end

    example 'parse the > axis called on another > axis' do
      parse_css('a > b > c').should == s(
        :axis,
        'child',
        s(:axis, 'child', s(:test, nil, 'a'), s(:test, nil, 'b')),
        s(:test, nil, 'c')
      )
    end

    example 'parse the + axis' do
      parse_css('x + y').should == s(
        :axis,
        'following-direct',
        s(:test, nil, 'x'),
        s(:test, nil, 'y')
      )
    end

    example 'parse the + axis called on another + axis' do
      parse_css('a + b + c').should == s(
        :axis,
        'following-direct',
        s(:axis, 'following-direct', s(:test, nil, 'a'), s(:test, nil, 'b')),
        s(:test, nil, 'c')
      )
    end

    example 'parse the ~ axis' do
      parse_css('x ~ y').should == s(
        :axis,
        'following',
        s(:test, nil, 'x'),
        s(:test, nil, 'y')
      )
    end

    example 'parse the ~ axis followed by another node test' do
      parse_css('x ~ y z').should == s(
        :path,
        s(:axis, 'following', s(:test, nil, 'x'), s(:test, nil, 'y')),
        s(:test, nil, 'z')
      )
    end

    example 'parse the ~ axis called on another ~ axis' do
      parse_css('a ~ b ~ c').should == s(
        :axis,
        'following',
        s(:axis, 'following', s(:test, nil, 'a'), s(:test, nil, 'b')),
        s(:test, nil, 'c')
      )
    end

    example 'parse a pseudo class followed by the ~ axis' do
      parse_css('x:root ~ a').should == s(
        :axis,
        'following',
        s(:pseudo, 'root', s(:test, nil, 'x')),
        s(:test, nil, 'a')
      )
    end

    example 'parse the ~ axis followed by a pseudo class' do
      parse_css('a ~ x:root').should == s(
        :axis,
        'following',
        s(:test, nil, 'a'),
        s(:pseudo, 'root', s(:test, nil, 'x'))
      )
    end
  end
end
