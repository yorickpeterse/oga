require 'spec_helper'

describe Oga::XPath::Parser do
  describe 'operators' do
    it 'parses the pipe operator' do
      expect(parse_xpath('A | B')).to eq(s(
        :pipe,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      ))
    end

    it 'parses the pipe operator using two paths' do
      expect(parse_xpath('A/B | C/D')).to eq(s(
        :pipe,
        s(
          :axis,
          'child',
          s(:test, nil, 'A'),
          s(:axis, 'child', s(:test, nil, 'B'))
        ),
        s(
          :axis,
          'child',
          s(:test, nil, 'C'),
          s(:axis, 'child', s(:test, nil, 'D'))
        )
      ))
    end

    it 'parses the and operator' do
      expect(parse_xpath('A and B')).to eq(s(
        :and,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      ))
    end

    it 'parses the or operator' do
      expect(parse_xpath('A or B')).to eq(s(
        :or,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      ))
    end

    it 'parses the plus operator' do
      expect(parse_xpath('A + B')).to eq(s(
        :add,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      ))
    end

    it 'parses the div operator' do
      expect(parse_xpath('A div B')).to eq(s(
        :div,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      ))
    end

    it 'parses the mod operator' do
      expect(parse_xpath('A mod B')).to eq(s(
        :mod,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      ))
    end

    it 'parses the equals operator' do
      expect(parse_xpath('A = B')).to eq(s(
        :eq,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      ))
    end

    it 'parses the not-equals operator' do
      expect(parse_xpath('A != B')).to eq(s(
        :neq,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      ))
    end

    it 'parses the lower-than operator' do
      expect(parse_xpath('A < B')).to eq(s(
        :lt,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      ))
    end

    it 'parses the greater-than operator' do
      expect(parse_xpath('A > B')).to eq(s(
        :gt,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      ))
    end

    it 'parses the lower-or-equal operator' do
      expect(parse_xpath('A <= B')).to eq(s(
        :lte,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      ))
    end

    it 'parses the greater-or-equal operator' do
      expect(parse_xpath('A >= B')).to eq(s(
        :gte,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      ))
    end

    it 'parses the mul operator' do
      expect(parse_xpath('A * B')).to eq(s(
        :mul,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      ))
    end

    it 'parses the subtraction operator' do
      expect(parse_xpath('A - B')).to eq(s(
        :sub,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      ))
    end
  end
end
