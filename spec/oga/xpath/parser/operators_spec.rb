require 'spec_helper'

describe Oga::XPath::Parser do
  context 'operators' do
    example 'parse the pipe operator' do
      parse_xpath('A | B').should == s(
        :pipe,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    example 'parse the pipe operator using two paths' do
      parse_xpath('A/B | C/D').should == s(
        :pipe,
        s(
          :path,
          s(:axis, 'child', s(:test, nil, 'A')),
          s(:axis, 'child', s(:test, nil, 'B'))
        ),
        s(
          :path,
          s(:axis, 'child', s(:test, nil, 'C')),
          s(:axis, 'child', s(:test, nil, 'D'))
        )
      )
    end

    example 'parse the and operator' do
      parse_xpath('A and B').should == s(
        :and,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    example 'parse the or operator' do
      parse_xpath('A or B').should == s(
        :or,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    example 'parse the plus operator' do
      parse_xpath('A + B').should == s(
        :add,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    example 'parse the div operator' do
      parse_xpath('A div B').should == s(
        :div,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    example 'parse the mod operator' do
      parse_xpath('A mod B').should == s(
        :mod,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    example 'parse the equals operator' do
      parse_xpath('A = B').should == s(
        :eq,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    example 'parse the not-equals operator' do
      parse_xpath('A != B').should == s(
        :neq,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    example 'parse the lower-than operator' do
      parse_xpath('A < B').should == s(
        :lt,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    example 'parse the greater-than operator' do
      parse_xpath('A > B').should == s(
        :gt,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    example 'parse the lower-or-equal operator' do
      parse_xpath('A <= B').should == s(
        :lte,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    example 'parse the greater-or-equal operator' do
      parse_xpath('A >= B').should == s(
        :gte,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    example 'parse the mul operator' do
      parse_xpath('A * B').should == s(
        :mul,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    example 'parse the subtraction operator' do
      parse_xpath('A - B').should == s(
        :sub,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end
  end
end
