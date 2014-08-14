require 'spec_helper'

describe Oga::XPath::Parser do
  context 'full axes' do
    example 'parse the ancestor axis' do
      parse_xpath('/ancestor::A').should == s(
        :absolute_path,
        s(:axis, 'ancestor', s(:test, nil, 'A'))
      )
    end

    example 'parse the ancestor-or-self axis' do
      parse_xpath('/ancestor-or-self::A').should == s(
        :absolute_path,
        s(:axis, 'ancestor-or-self', s(:test, nil, 'A'))
      )
    end

    example 'parse the attribute axis' do
      parse_xpath('/attribute::A').should == s(
        :absolute_path,
        s(:axis, 'attribute', s(:test, nil, 'A'))
      )
    end

    example 'parse the child axis' do
      parse_xpath('/child::A').should == s(
        :absolute_path,
        s(:axis, 'child', s(:test, nil, 'A'))
      )
    end

    example 'parse the descendant axis' do
      parse_xpath('/descendant::A').should == s(
        :absolute_path,
        s(:axis, 'descendant', s(:test, nil, 'A'))
      )
    end

    example 'parse the descendant-or-self axis' do
      parse_xpath('/descendant-or-self::A').should == s(
        :absolute_path,
        s(:axis, 'descendant-or-self', s(:test, nil, 'A'))
      )
    end

    example 'parse the following axis' do
      parse_xpath('/following::A').should == s(
        :absolute_path,
        s(:axis, 'following', s(:test, nil, 'A'))
      )
    end

    example 'parse the following-sibling axis' do
      parse_xpath('/following-sibling::A').should == s(
        :absolute_path,
        s(:axis, 'following-sibling', s(:test, nil, 'A'))
      )
    end

    example 'parse the namespace axis' do
      parse_xpath('/namespace::A').should == s(
        :absolute_path,
        s(:axis, 'namespace', s(:test, nil, 'A'))
      )
    end

    example 'parse the parent axis' do
      parse_xpath('/parent::A').should == s(
        :absolute_path,
        s(:axis, 'parent', s(:test, nil, 'A'))
      )
    end

    example 'parse the preceding axis' do
      parse_xpath('/preceding::A').should == s(
        :absolute_path,
        s(:axis, 'preceding', s(:test, nil, 'A'))
      )
    end

    example 'parse the preceding-sibling axis' do
      parse_xpath('/preceding-sibling::A').should == s(
        :absolute_path,
        s(:axis, 'preceding-sibling', s(:test, nil, 'A'))
      )
    end

    example 'parse the self axis' do
      parse_xpath('/self::A').should == s(
        :absolute_path,
        s(:axis, 'self', s(:test, nil, 'A'))
      )
    end
  end

  context 'short axes' do
    example 'parse the @attribute axis' do
      parse_xpath('/@A').should == s(
        :absolute_path,
        s(:axis, 'attribute', s(:test, nil, 'A'))
      )
    end

    example 'parse the // axis' do
      parse_xpath('//A').should == s(
        :absolute_path,
        s(:axis, 'descendant-or-self', s(:node_type, 'node')),
        s(:axis, 'child', s(:test, nil, 'A'))
      )
    end

    example 'parse the .. axis' do
      parse_xpath('/..').should == s(
        :absolute_path,
        s(:axis, 'parent', s(:node_type, 'node'))
      )
    end

    example 'parse the . axis' do
      parse_xpath('/.').should == s(
        :absolute_path,
        s(:axis, 'self', s(:node_type, 'node'))
      )
    end
  end
end
