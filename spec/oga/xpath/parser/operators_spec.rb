require 'spec_helper'

describe Oga::XPath::Parser do
  context 'operators' do
    example 'parse the pipe operator' do
      parse_xpath('A | B').should == s(
        :path,
        s(:pipe, s(:test, nil, 'A'), s(:test, nil, 'B'))
      )
    end

    example 'parse the and operator' do
      parse_xpath('A and B').should == s(
        :path,
        s(:and, s(:test, nil, 'A'), s(:test, nil, 'B'))
      )
    end

    example 'parse the or operator' do
      parse_xpath('A or B').should == s(
        :path,
        s(:or, s(:test, nil, 'A'), s(:test, nil, 'B'))
      )
    end

    example 'parse the plus operator' do
      parse_xpath('A + B').should == s(
        :path,
        s(:add, s(:test, nil, 'A'), s(:test, nil, 'B'))
      )
    end

    example 'parse the div operator' do
      parse_xpath('A div B').should == s(
        :path,
        s(:div, s(:test, nil, 'A'), s(:test, nil, 'B'))
      )
    end

    example 'parse the mod operator' do
      parse_xpath('A mod B').should == s(
        :path,
        s(:mod, s(:test, nil, 'A'), s(:test, nil, 'B'))
      )
    end

    example 'parse the equals operator' do
      parse_xpath('A = B').should == s(
        :path,
        s(:eq, s(:test, nil, 'A'), s(:test, nil, 'B'))
      )
    end

    example 'parse the not-equals operator' do
      parse_xpath('A != B').should == s(
        :path,
        s(:neq, s(:test, nil, 'A'), s(:test, nil, 'B'))
      )
    end

    example 'parse the lower-than operator' do
      parse_xpath('A < B').should == s(
        :path,
        s(:lt, s(:test, nil, 'A'), s(:test, nil, 'B'))
      )
    end

    example 'parse the greater-than operator' do
      parse_xpath('A > B').should == s(
        :path,
        s(:gt, s(:test, nil, 'A'), s(:test, nil, 'B'))
      )
    end

    example 'parse the lower-or-equal operator' do
      parse_xpath('A <= B').should == s(
        :path,
        s(:lte, s(:test, nil, 'A'), s(:test, nil, 'B'))
      )
    end

    example 'parse the greater-or-equal operator' do
      parse_xpath('A >= B').should == s(
        :path,
        s(:gte, s(:test, nil, 'A'), s(:test, nil, 'B'))
      )
    end

    example 'parse the mul operator' do
      parse_xpath('A * B').should == s(
        :path,
        s(:mul, s(:test, nil, 'A'), s(:test, nil, 'B'))
      )
    end

    example 'parse the subtraction operator' do
      parse_xpath('A - B').should == s(
        :path,
        s(:sub, s(:test, nil, 'A'), s(:test, nil, 'B'))
      )
    end
  end
end
