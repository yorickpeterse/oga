require 'spec_helper'

describe Oga::XPath::Parser do
  describe 'operators' do
    it 'parses the pipe operator' do
      parse_xpath('A | B').should == s(
        :pipe,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    it 'parses the pipe operator using two paths' do
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

    it 'parses the and operator' do
      parse_xpath('A and B').should == s(
        :and,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    it 'parses the or operator' do
      parse_xpath('A or B').should == s(
        :or,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    it 'parses the plus operator' do
      parse_xpath('A + B').should == s(
        :add,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    it 'parses the div operator' do
      parse_xpath('A div B').should == s(
        :div,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    it 'parses the mod operator' do
      parse_xpath('A mod B').should == s(
        :mod,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    it 'parses the equals operator' do
      parse_xpath('A = B').should == s(
        :eq,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    it 'parses the not-equals operator' do
      parse_xpath('A != B').should == s(
        :neq,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    it 'parses the lower-than operator' do
      parse_xpath('A < B').should == s(
        :lt,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    it 'parses the greater-than operator' do
      parse_xpath('A > B').should == s(
        :gt,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    it 'parses the lower-or-equal operator' do
      parse_xpath('A <= B').should == s(
        :lte,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    it 'parses the greater-or-equal operator' do
      parse_xpath('A >= B').should == s(
        :gte,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    it 'parses the mul operator' do
      parse_xpath('A * B').should == s(
        :mul,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    it 'parses the subtraction operator' do
      parse_xpath('A - B').should == s(
        :sub,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end
  end
end
