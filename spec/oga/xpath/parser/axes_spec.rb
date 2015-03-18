require 'spec_helper'

describe Oga::XPath::Parser do
  describe 'full axes' do
    it 'parses the ancestor axis' do
      parse_xpath('/ancestor::A').should == s(
        :absolute_path,
        s(:axis, 'ancestor', s(:test, nil, 'A'))
      )
    end

    it 'parses the ancestor axis with a predicate' do
      parse_xpath('/ancestor::A[1]').should == s(
        :absolute_path,
        s(:predicate, s(:axis, 'ancestor', s(:test, nil, 'A')), s(:int, 1))
      )
    end

    it 'parses the ancestor-or-self axis' do
      parse_xpath('/ancestor-or-self::A').should == s(
        :absolute_path,
        s(:axis, 'ancestor-or-self', s(:test, nil, 'A'))
      )
    end

    it 'parses the attribute axis' do
      parse_xpath('/attribute::A').should == s(
        :absolute_path,
        s(:axis, 'attribute', s(:test, nil, 'A'))
      )
    end

    it 'parses the child axis' do
      parse_xpath('/child::A').should == s(
        :absolute_path,
        s(:axis, 'child', s(:test, nil, 'A'))
      )
    end

    it 'parses the descendant axis' do
      parse_xpath('/descendant::A').should == s(
        :absolute_path,
        s(:axis, 'descendant', s(:test, nil, 'A'))
      )
    end

    it 'parses the descendant-or-self axis' do
      parse_xpath('/descendant-or-self::A').should == s(
        :absolute_path,
        s(:axis, 'descendant-or-self', s(:test, nil, 'A'))
      )
    end

    it 'parses the following axis' do
      parse_xpath('/following::A').should == s(
        :absolute_path,
        s(:axis, 'following', s(:test, nil, 'A'))
      )
    end

    it 'parses the following-sibling axis' do
      parse_xpath('/following-sibling::A').should == s(
        :absolute_path,
        s(:axis, 'following-sibling', s(:test, nil, 'A'))
      )
    end

    it 'parses the namespace axis' do
      parse_xpath('/namespace::A').should == s(
        :absolute_path,
        s(:axis, 'namespace', s(:test, nil, 'A'))
      )
    end

    it 'parses the parent axis' do
      parse_xpath('/parent::A').should == s(
        :absolute_path,
        s(:axis, 'parent', s(:test, nil, 'A'))
      )
    end

    it 'parses the preceding axis' do
      parse_xpath('/preceding::A').should == s(
        :absolute_path,
        s(:axis, 'preceding', s(:test, nil, 'A'))
      )
    end

    it 'parses the preceding-sibling axis' do
      parse_xpath('/preceding-sibling::A').should == s(
        :absolute_path,
        s(:axis, 'preceding-sibling', s(:test, nil, 'A'))
      )
    end

    it 'parses the self axis' do
      parse_xpath('/self::A').should == s(
        :absolute_path,
        s(:axis, 'self', s(:test, nil, 'A'))
      )
    end
  end

  describe 'short axes' do
    it 'parses the @attribute axis' do
      parse_xpath('/@A').should == s(
        :absolute_path,
        s(:axis, 'attribute', s(:test, nil, 'A'))
      )
    end

    it 'parses the // axis' do
      parse_xpath('//A').should == s(
        :absolute_path,
        s(:axis, 'descendant-or-self', s(:type_test, 'node')),
        s(:axis, 'child', s(:test, nil, 'A'))
      )
    end

    it 'parses the .. axis' do
      parse_xpath('/..').should == s(
        :absolute_path,
        s(:axis, 'parent', s(:type_test, 'node'))
      )
    end

    it 'parses the . axis' do
      parse_xpath('/.').should == s(
        :absolute_path,
        s(:axis, 'self', s(:type_test, 'node'))
      )
    end
  end
end
