require 'spec_helper'

describe Oga::XPath::Parser do
  describe 'grouping of expressions' do
    it 'parses "A + (B + C)"' do
      expect(parse_xpath('A + (B + C)')).to eq(s(
        :add,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(
          :add,
          s(:axis, 'child', s(:test, nil, 'B')),
          s(:axis, 'child', s(:test, nil, 'C'))
        )
      ))
    end

    it 'parses "A or (B or C)"' do
      expect(parse_xpath('A or (B or C)')).to eq(s(
        :or,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(
          :or,
          s(:axis, 'child', s(:test, nil, 'B')),
          s(:axis, 'child', s(:test, nil, 'C'))
        )
      ))
    end

    it 'parses "(A or B) and C"' do
      expect(parse_xpath('(A or B) and C')).to eq(s(
        :and,
        s(
          :or,
          s(:axis, 'child', s(:test, nil, 'A')),
          s(:axis, 'child', s(:test, nil, 'B'))
        ),
        s(:axis, 'child', s(:test, nil, 'C'))
      ))
    end
  end
end
