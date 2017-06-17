require 'spec_helper'

describe Oga::XPath::Parser do
  describe 'operator precedence' do
    it 'parses "A or B or C"' do
      expect(parse_xpath('A or B or C')).to eq(s(
        :or,
        s(
          :or,
          s(:axis, 'child', s(:test, nil, 'A')),
          s(:axis, 'child', s(:test, nil, 'B'))
        ),
        s(:axis, 'child', s(:test, nil, 'C'))
      ))
    end

    it 'parses "A and B and C"' do
      expect(parse_xpath('A and B and C')).to eq(s(
        :and,
        s(
          :and,
          s(:axis, 'child', s(:test, nil, 'A')),
          s(:axis, 'child', s(:test, nil, 'B'))
        ),
        s(:axis, 'child', s(:test, nil, 'C'))
      ))
    end

    it 'parses "A = B = C"' do
      expect(parse_xpath('A = B = C')).to eq(s(
        :eq,
        s(
          :eq,
          s(:axis, 'child', s(:test, nil, 'A')),
          s(:axis, 'child', s(:test, nil, 'B'))
        ),
        s(:axis, 'child', s(:test, nil, 'C'))
      ))
    end

    it 'parses "A != B != C"' do
      expect(parse_xpath('A != B != C')).to eq(s(
        :neq,
        s(
          :neq,
          s(:axis, 'child', s(:test, nil, 'A')),
          s(:axis, 'child', s(:test, nil, 'B'))
        ),
        s(:axis, 'child', s(:test, nil, 'C'))
      ))
    end

    it 'parses "A <= B <= C"' do
      expect(parse_xpath('A <= B <= C')).to eq(s(
        :lte,
        s(
          :lte,
          s(:axis, 'child', s(:test, nil, 'A')),
          s(:axis, 'child', s(:test, nil, 'B'))
        ),
        s(:axis, 'child', s(:test, nil, 'C'))
      ))
    end

    it 'parses "A < B < C"' do
      expect(parse_xpath('A < B < C')).to eq(s(
        :lt,
        s(
          :lt,
          s(:axis, 'child', s(:test, nil, 'A')),
          s(:axis, 'child', s(:test, nil, 'B'))
        ),
        s(:axis, 'child', s(:test, nil, 'C'))
      ))
    end

    it 'parses "A >= B >= C"' do
      expect(parse_xpath('A >= B >= C')).to eq(s(
        :gte,
        s(
          :gte,
          s(:axis, 'child', s(:test, nil, 'A')),
          s(:axis, 'child', s(:test, nil, 'B'))
        ),
        s(:axis, 'child', s(:test, nil, 'C'))
      ))
    end

    it 'parses "A > B > C"' do
      expect(parse_xpath('A > B > C')).to eq(s(
        :gt,
        s(
          :gt,
          s(:axis, 'child', s(:test, nil, 'A')),
          s(:axis, 'child', s(:test, nil, 'B'))
        ),
        s(:axis, 'child', s(:test, nil, 'C'))
      ))
    end

    it 'parses "A or B and C"' do
      expect(parse_xpath('A or B and C')).to eq(s(
        :or,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(
          :and,
          s(:axis, 'child', s(:test, nil, 'B')),
          s(:axis, 'child', s(:test, nil, 'C'))
        )
      ))
    end

    it 'parses "A and B = C"' do
      expect(parse_xpath('A and B = C')).to eq(s(
        :and,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(
          :eq,
          s(:axis, 'child', s(:test, nil, 'B')),
          s(:axis, 'child', s(:test, nil, 'C'))
        )
      ))
    end

    it 'parses "A = B < C"' do
      expect(parse_xpath('A = B < C')).to eq(s(
        :eq,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(
          :lt,
          s(:axis, 'child', s(:test, nil, 'B')),
          s(:axis, 'child', s(:test, nil, 'C'))
        )
      ))
    end

    it 'parses "A < B | C"' do
      expect(parse_xpath('A < B | C')).to eq(s(
        :lt,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(
          :pipe,
          s(:axis, 'child', s(:test, nil, 'B')),
          s(:axis, 'child', s(:test, nil, 'C'))
        )
      ))
    end

    it 'parses "A > B or C"' do
      expect(parse_xpath('A > B or C')).to eq(s(
        :or,
        s(
          :gt,
          s(:axis, 'child', s(:test, nil, 'A')),
          s(:axis, 'child', s(:test, nil, 'B'))
        ),
        s(:axis, 'child', s(:test, nil, 'C'))
      ))
    end
  end
end
