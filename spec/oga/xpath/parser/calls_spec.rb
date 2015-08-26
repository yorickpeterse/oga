require 'spec_helper'

describe Oga::XPath::Parser do
  describe 'function calls' do
    it 'parses a function call without arguments' do
      parse_xpath('count()').should == s(:call, 'count')
    end

    it 'parses a function call with a single argument' do
      parse_xpath('count(/foo)').should == s(
        :call,
        'count',
        s(:absolute_path, s(:axis, 'child', s(:test, nil, 'foo')))
      )
    end

    it 'parses a function call with two arguments' do
      parse_xpath('count(/foo, "bar")').should == s(
        :call,
        'count',
        s(:absolute_path, s(:axis, 'child', s(:test, nil, 'foo'))),
        s(:string, 'bar')
      )
    end

    it 'parses a relative path with a function call' do
      parse_xpath('foo/bar()').should ==
        s(:axis, 'child', s(:test, nil, 'foo'), s(:call, 'bar'))
    end

    it 'parses an absolute path with a function call' do
      parse_xpath('/foo/bar()').should == s(
        :absolute_path,
        s(:axis, 'child', s(:test, nil, 'foo'), s(:call, 'bar'))
      )
    end

    it 'parses a predicate followed by a function call' do
      parse_xpath('div[@class="foo"]/bar()').should == s(
        :predicate,
        s(:axis, 'child', s(:test, nil, 'div')),
        s(
          :eq,
          s(:axis, 'attribute', s(:test, nil, 'class')),
          s(:string, 'foo')
        ),
        s(:call, 'bar')
      )
    end

    it 'parses two predicates followed by a function call' do
      parse_xpath('A[@x]/B[@x]/bar()').should == s(
        :predicate,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'attribute', s(:test, nil, 'x')),
        s(
          :predicate,
          s(:axis, 'child', s(:test, nil, 'B')),
          s(:axis, 'attribute', s(:test, nil, 'x')),
          s(:call, 'bar')
        )
      )
    end

    it 'parses a function call inside a predicate' do
      parse_xpath('A[foo()]').should == s(
        :predicate,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:call, 'foo')
      )
    end
  end
end
