require 'spec_helper'

describe Oga::XPath::Parser do
  context 'operators' do
    example 'parse the pipe operator' do
      parse_xpath('A | B').should == s(
        :pipe,
        s(:test, nil, 'A'),
        s(:test, nil, 'B')
      )
    end

    example 'parse the pipe operator using two paths' do
      parse_xpath('A/B | C/D').should == s(
        :pipe,
        s(:path, s(:test, nil, 'A'), s(:test, nil, 'B')),
        s(:path, s(:test, nil, 'C'), s(:test, nil, 'D'))
      )
    end

    example 'parse the and operator' do
      parse_xpath('A and B').should == s(
        :and,
        s(:test, nil, 'A'),
        s(:test, nil, 'B')
      )
    end

    example 'parse the or operator' do
      parse_xpath('A or B').should == s(
        :or,
        s(:test, nil, 'A'),
        s(:test, nil, 'B')
      )
    end

    example 'parse the plus operator' do
      parse_xpath('A + B').should == s(
        :add,
        s(:test, nil, 'A'),
        s(:test, nil, 'B')
      )
    end

    example 'parse the div operator' do
      parse_xpath('A div B').should == s(
        :div,
        s(:test, nil, 'A'),
        s(:test, nil, 'B')
      )
    end

    example 'parse the mod operator' do
      parse_xpath('A mod B').should == s(
        :mod,
        s(:test, nil, 'A'),
        s(:test, nil, 'B')
      )
    end

    example 'parse the equals operator' do
      parse_xpath('A = B').should == s(
        :eq,
        s(:test, nil, 'A'),
        s(:test, nil, 'B')
      )
    end

    example 'parse the not-equals operator' do
      parse_xpath('A != B').should == s(
        :neq,
        s(:test, nil, 'A'),
        s(:test, nil, 'B')
      )
    end

    example 'parse the lower-than operator' do
      parse_xpath('A < B').should == s(
        :lt,
        s(:test, nil, 'A'),
        s(:test, nil, 'B')
      )
    end

    example 'parse the greater-than operator' do
      parse_xpath('A > B').should == s(
        :gt,
        s(:test, nil, 'A'),
        s(:test, nil, 'B')
      )
    end

    example 'parse the lower-or-equal operator' do
      parse_xpath('A <= B').should == s(
        :lte,
        s(:test, nil, 'A'),
        s(:test, nil, 'B')
      )
    end

    example 'parse the greater-or-equal operator' do
      parse_xpath('A >= B').should == s(
        :gte,
        s(:test, nil, 'A'),
        s(:test, nil, 'B')
      )
    end

    example 'parse the mul operator' do
      parse_xpath('A * B').should == s(
        :mul,
        s(:test, nil, 'A'),
        s(:test, nil, 'B')
      )
    end

    example 'parse the subtraction operator' do
      parse_xpath('A - B').should == s(
        :sub,
        s(:test, nil, 'A'),
        s(:test, nil, 'B')
      )
    end
  end
end
