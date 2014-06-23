require 'spec_helper'

describe Oga::XPath::Parser do
  context 'function calls' do
    example 'parse a function call without arguments' do
      parse_xpath('count()').should == s(:path, s(:call, 'count'))
    end

    example 'parse a function call with a single argument' do
      parse_xpath('count(/foo)').should == s(
        :path,
        s(:call, 'count', s(:absolute, s(:path, s(:test, nil, 'foo'))))
      )
    end

    example 'parse a function call with two arguments' do
      parse_xpath('count(/foo, "bar")').should == s(
        :path,
        s(
          :call,
          'count',
          s(:absolute, s(:path, s(:test, nil, 'foo'))),
          s(:path, s(:string, 'bar'))
        )
      )
    end

    example 'parse a relative path with a function call' do
      parse_xpath('foo/bar()').should == s(
        :path,
        s(:test, nil, 'foo'),
        s(:path, s(:call, 'bar'))
      )
    end

    example 'parse an absolute path with a function call' do
      parse_xpath('/foo/bar()').should == s(
        :absolute,
        s(:path, s(:test, nil, 'foo'), s(:path, s(:call, 'bar')))
      )
    end

    example 'parse a predicate followed by a function call' do
      parse_xpath('div[@class="foo"]/bar()').should == s(
        :path,
        s(
          :test,
          nil,
          'div',
          s(
            :path,
            s(
              :eq,
              s(:axis, 'attribute', s(:test, nil, 'class')),
              s(:string, 'foo')
            )
          )
        ),
        s(:path, s(:call, 'bar'))
      )
    end

    example 'parse two predicates followed by a function call' do
      parse_xpath('A[@class]/B[@class]/bar()').should == s(
        :path,
        s(
          :test,
          nil,
          'A',
          s(:path, s(:axis, 'attribute', s(:test, nil, 'class')))),
        s(
          :path,
          s(
            :test,
            nil,
            'B',
            s(:path, s(:axis, 'attribute', s(:test, nil, 'class')))
          ),
          s(:path, s(:call, 'bar'))
        )
      )
    end
  end
end
