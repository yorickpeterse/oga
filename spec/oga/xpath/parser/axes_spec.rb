require 'spec_helper'

describe Oga::XPath::Parser do
  context 'full axes' do
    example 'parse the ancestor axis' do
      parse_xpath('/ancestor::A').should == s(
        :xpath,
        s(:path, s(:node_test, s(:axis, 'ancestor', s(:name, nil, 'A'))))
      )
    end

    example 'parse the ancestor-or-self axis' do
      parse_xpath('/ancestor-or-self::A').should == s(
        :xpath,
        s(
          :path,
          s(:node_test, s(:axis, 'ancestor-or-self', s(:name, nil, 'A')))
        )
      )
    end

    example 'parse the attribute axis' do
      parse_xpath('/attribute::A').should == s(
        :xpath,
        s(:path, s(:node_test, s(:axis, 'attribute', s(:name, nil, 'A'))))
      )
    end

    example 'parse the child axis' do
      parse_xpath('/child::A').should == s(
        :xpath,
        s(:path, s(:node_test, s(:axis, 'child', s(:name, nil, 'A'))))
      )
    end

    example 'parse the descendant axis' do
      parse_xpath('/descendant::A').should == s(
        :xpath,
        s(:path, s(:node_test, s(:axis, 'descendant', s(:name, nil, 'A'))))
      )
    end

    example 'parse the descendant-or-self axis' do
      parse_xpath('/descendant-or-self::A').should == s(
        :xpath,
        s(
          :path,
          s(:node_test, s(:axis, 'descendant-or-self', s(:name, nil, 'A')))
        )
      )
    end

    example 'parse the following axis' do
      parse_xpath('/following::A').should == s(
        :xpath,
        s(:path, s(:node_test, s(:axis, 'following', s(:name, nil, 'A'))))
      )
    end

    example 'parse the following-sibling axis' do
      parse_xpath('/following-sibling::A').should == s(
        :xpath,
        s(
          :path,
          s(:node_test, s(:axis, 'following-sibling', s(:name, nil, 'A')))
        )
      )
    end

    example 'parse the namespace axis' do
      parse_xpath('/namespace::A').should == s(
        :xpath,
        s(:path, s(:node_test, s(:axis, 'namespace', s(:name, nil, 'A'))))
      )
    end

    example 'parse the parent axis' do
      parse_xpath('/parent::A').should == s(
        :xpath,
        s(:path, s(:node_test, s(:axis, 'parent', s(:name, nil, 'A'))))
      )
    end

    example 'parse the preceding axis' do
      parse_xpath('/preceding::A').should == s(
        :xpath,
        s(:path, s(:node_test, s(:axis, 'preceding', s(:name, nil, 'A'))))
      )
    end

    example 'parse the preceding-sibling axis' do
      parse_xpath('/preceding-sibling::A').should == s(
        :xpath,
        s(
          :path,
          s(:node_test, s(:axis, 'preceding-sibling', s(:name, nil, 'A')))
        )
      )
    end

    example 'parse the self axis' do
      parse_xpath('/self::A').should == s(
        :xpath,
        s(:path, s(:node_test, s(:axis, 'self', s(:name, nil, 'A'))))
      )
    end
  end

  context 'short axes' do
    example 'parse the @attribute axis' do
      parse_xpath('/@A').should == s(
        :xpath,
        s(:path, s(:node_test, s(:axis, 'attribute', s(:name, nil, 'A'))))
      )
    end

    example 'parse the // axis' do
      parse_xpath('//A').should == s(
        :xpath,
        s(
          :path,
          s(:node_test, s(:axis, 'descendant-or-self', s(:name, nil, 'A')))
        )
      )
    end

    example 'parse the .. axis' do
      parse_xpath('/..').should == s(
        :xpath,
        s(:path, s(:node_test, s(:axis, 'parent')))
      )
    end

    example 'parse the . axis' do
      parse_xpath('/.').should == s(
        :xpath,
        s(:path, s(:node_test, s(:axis, 'self')))
      )
    end
  end
end
