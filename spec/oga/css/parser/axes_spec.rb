require 'spec_helper'

describe Oga::CSS::Parser do
  context 'axes' do
    example 'parse the > axis' do
      parse_css('x > y').should == s(
        :child,
        s(:test, nil, 'x'),
        s(:test, nil, 'y')
      )
    end

    example 'parse the > axis called on another > axis' do
      parse_css('a > b > c').should == s(
        :child,
        s(:child, s(:test, nil, 'a'), s(:test, nil, 'b')),
        s(:test, nil, 'c')
      )
    end

    example 'parse an > axis followed by an element with an ID' do
      parse_css('x > foo#bar').should == s(
        :child,
        s(:test, nil, 'x'),
        s(:id, 'bar', s(:test, nil, 'foo'))
      )
    end

    example 'parse an > axis followed by an element with a class' do
      parse_css('x > foo.bar').should == s(
        :child,
        s(:test, nil, 'x'),
        s(:class, 'bar', s(:test, nil, 'foo'))
      )
    end

    example 'parse the + axis' do
      parse_css('x + y').should == s(
        :following_direct,
        s(:test, nil, 'x'),
        s(:test, nil, 'y')
      )
    end

    example 'parse the + axis called on another + axis' do
      parse_css('a + b + c').should == s(
        :following_direct,
        s(:following_direct, s(:test, nil, 'a'), s(:test, nil, 'b')),
        s(:test, nil, 'c')
      )
    end

    example 'parse the ~ axis' do
      parse_css('x ~ y').should == s(
        :following,
        s(:test, nil, 'x'),
        s(:test, nil, 'y')
      )
    end

    example 'parse the ~ axis followed by another node test' do
      parse_css('x ~ y z').should == s(
        :path,
        s(:following, s(:test, nil, 'x'), s(:test, nil, 'y')),
        s(:test, nil, 'z')
      )
    end

    example 'parse the ~ axis called on another ~ axis' do
      parse_css('a ~ b ~ c').should == s(
        :following,
        s(:following, s(:test, nil, 'a'), s(:test, nil, 'b')),
        s(:test, nil, 'c')
      )
    end

    example 'parse a pseudo class followed by the ~ axis' do
      parse_css('x:root ~ a').should == s(
        :following,
        s(:pseudo, 'root', s(:test, nil, 'x')),
        s(:test, nil, 'a')
      )
    end

    example 'parse the ~ axis followed by a pseudo class' do
      parse_css('a ~ x:root').should == s(
        :following,
        s(:test, nil, 'a'),
        s(:pseudo, 'root', s(:test, nil, 'x'))
      )
    end
  end
end
