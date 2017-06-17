require 'spec_helper'

describe Oga::XPath::Parser do
  describe 'paths' do
    it 'parses an absolute path' do
      expect(parse_xpath('/A')).to eq(s(
        :absolute_path,
        s(:axis, 'child', s(:test, nil, 'A'))
      ))
    end

    it 'parses a relative path' do
      expect(parse_xpath('A')).to eq(s(:axis, 'child', s(:test, nil, 'A')))
    end

    it 'parses a relative path using two steps' do
      expect(parse_xpath('A/B')).to eq(s(
        :axis,
        'child',
        s(:test, nil, 'A'),
        s(:axis, 'child', s(:test, nil, 'B'))
      ))
    end

    it 'parses a relative path using three steps' do
      expect(parse_xpath('A/B/C')).to eq(s(
        :axis,
        'child',
        s(:test, nil, 'A'),
        s(
          :axis,
          'child',
          s(:test, nil, 'B'),
          s(:axis, 'child', s(:test, nil, 'C'))
        )
      ))
    end

    it 'parses an expression using two paths' do
      expect(parse_xpath('/A/B')).to eq(s(
        :absolute_path,
        s(
          :axis,
          'child',
          s(:test, nil, 'A'),
          s(:axis, 'child', s(:test, nil, 'B'))
        )
      ))
    end

    it 'parses an expression using three paths' do
      expect(parse_xpath('/A/B/C')).to eq(s(
        :absolute_path,
        s(
          :axis,
          'child',
          s(:test, nil, 'A'),
          s(
            :axis,
            'child',
            s(:test, nil, 'B'),
            s(:axis, 'child', s(:test, nil, 'C'))
          )
        )
      ))
    end

    it 'parses an absolute path without a node test' do
      expect(parse_xpath('/')).to eq(s(:absolute_path))
    end
  end
end
