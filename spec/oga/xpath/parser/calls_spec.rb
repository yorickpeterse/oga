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
  end
end
