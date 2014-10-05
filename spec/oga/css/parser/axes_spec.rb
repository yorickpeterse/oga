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

    example 'parse the + axis' do
      parse_css('x + y').should == s(
        :axis,
        'following-direct',
        s(:test, nil, 'x'),
        s(:test, nil, 'y')
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
  end
end
