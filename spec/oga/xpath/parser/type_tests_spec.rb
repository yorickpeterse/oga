require 'spec_helper'

describe Oga::XPath::Parser do
  describe 'node() type test' do
    it 'parses the standalone type test' do
      expect(parse_xpath('node()')).to eq(s(:axis, 'child', s(:type_test, 'node')))
    end

    it 'parses the type test in a predicate' do
      expect(parse_xpath('node()[1]')).to eq(s(
        :predicate,
        s(:axis, 'child', s(:type_test, 'node')),
        s(:int, 1)
      ))
    end
  end

  describe 'comment() type test' do
    it 'parses the standalone type test' do
      expect(parse_xpath('comment()')).to eq(s(:axis, 'child', s(:type_test, 'comment')))
    end

    it 'parses the type test in a predicate' do
      expect(parse_xpath('comment()[1]')).to eq(s(
        :predicate,
        s(:axis, 'child', s(:type_test, 'comment')),
        s(:int, 1)
      ))
    end
  end

  describe 'text() type test' do
    it 'parses the standalone type test' do
      expect(parse_xpath('text()')).to eq(s(:axis, 'child', s(:type_test, 'text')))
    end

    it 'parses the type test in a predicate' do
      expect(parse_xpath('text()[1]')).to eq(s(
        :predicate,
        s(:axis, 'child', s(:type_test, 'text')),
        s(:int, 1)
      ))
    end
  end

  describe 'processing-instruction() type test' do
    it 'parses the standalone type test' do
      expect(parse_xpath('processing-instruction()')).to eq(
        s(:axis, 'child', s(:type_test, 'processing-instruction'))
      )
    end

    it 'parses the type test in a predicate' do
      expect(parse_xpath('processing-instruction()[1]')).to eq(s(
        :predicate,
        s(:axis, 'child', s(:type_test, 'processing-instruction')),
        s(:int, 1)
      ))
    end
  end
end
