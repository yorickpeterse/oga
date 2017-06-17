require 'spec_helper'

describe Oga::XPath::Parser do
  describe 'full axes' do
    it 'parses the ancestor axis' do
      expect(parse_xpath('/ancestor::A')).to eq(s(
        :absolute_path,
        s(:axis, 'ancestor', s(:test, nil, 'A'))
      ))
    end

    it 'parses the ancestor axis with a predicate' do
      expect(parse_xpath('/ancestor::A[1]')).to eq(s(
        :absolute_path,
        s(:predicate, s(:axis, 'ancestor', s(:test, nil, 'A')), s(:int, 1))
      ))
    end

    it 'parses the ancestor-or-self axis' do
      expect(parse_xpath('/ancestor-or-self::A')).to eq(s(
        :absolute_path,
        s(:axis, 'ancestor-or-self', s(:test, nil, 'A'))
      ))
    end

    it 'parses the attribute axis' do
      expect(parse_xpath('/attribute::A')).to eq(s(
        :absolute_path,
        s(:axis, 'attribute', s(:test, nil, 'A'))
      ))
    end

    it 'parses the child axis' do
      expect(parse_xpath('/child::A')).to eq(s(
        :absolute_path,
        s(:axis, 'child', s(:test, nil, 'A'))
      ))
    end

    it 'parses the descendant axis' do
      expect(parse_xpath('/descendant::A')).to eq(s(
        :absolute_path,
        s(:axis, 'descendant', s(:test, nil, 'A'))
      ))
    end

    it 'parses the descendant-or-self axis' do
      expect(parse_xpath('/descendant-or-self::A')).to eq(s(
        :absolute_path,
        s(:axis, 'descendant-or-self', s(:test, nil, 'A'))
      ))
    end

    it 'parses the following axis' do
      expect(parse_xpath('/following::A')).to eq(s(
        :absolute_path,
        s(:axis, 'following', s(:test, nil, 'A'))
      ))
    end

    it 'parses the following-sibling axis' do
      expect(parse_xpath('/following-sibling::A')).to eq(s(
        :absolute_path,
        s(:axis, 'following-sibling', s(:test, nil, 'A'))
      ))
    end

    it 'parses the namespace axis' do
      expect(parse_xpath('/namespace::A')).to eq(s(
        :absolute_path,
        s(:axis, 'namespace', s(:test, nil, 'A'))
      ))
    end

    it 'parses the parent axis' do
      expect(parse_xpath('/parent::A')).to eq(s(
        :absolute_path,
        s(:axis, 'parent', s(:test, nil, 'A'))
      ))
    end

    it 'parses the preceding axis' do
      expect(parse_xpath('/preceding::A')).to eq(s(
        :absolute_path,
        s(:axis, 'preceding', s(:test, nil, 'A'))
      ))
    end

    it 'parses the preceding-sibling axis' do
      expect(parse_xpath('/preceding-sibling::A')).to eq(s(
        :absolute_path,
        s(:axis, 'preceding-sibling', s(:test, nil, 'A'))
      ))
    end

    it 'parses the self axis' do
      expect(parse_xpath('/self::A')).to eq(s(
        :absolute_path,
        s(:axis, 'self', s(:test, nil, 'A'))
      ))
    end
  end

  describe 'short axes' do
    it 'parses the @attribute axis' do
      expect(parse_xpath('/@A')).to eq(s(
        :absolute_path,
        s(:axis, 'attribute', s(:test, nil, 'A'))
      ))
    end

    it 'parses the // axis' do
      expect(parse_xpath('//A')).to eq(s(
        :absolute_path,
        s(
          :axis,
          'descendant-or-self',
          s(:type_test, 'node'),
          s(:axis, 'child', s(:test, nil, 'A'))
        ),
      ))
    end

    it 'parses the .. axis' do
      expect(parse_xpath('/..')).to eq(s(
        :absolute_path,
        s(:axis, 'parent', s(:type_test, 'node'))
      ))
    end

    it 'parses the . axis' do
      expect(parse_xpath('/.')).to eq(s(
        :absolute_path,
        s(:axis, 'self', s(:type_test, 'node'))
      ))
    end
  end
end
