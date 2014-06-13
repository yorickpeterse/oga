require 'spec_helper'

describe Oga::XPath::Parser do
  context 'paths' do
    example 'parse an absolute path' do
      parse_xpath('/foo').should == s(
        :xpath,
        s(:path, s(:node_test, s(:name, nil, 'foo')))
      )
    end

    example 'parse a relative path' do
      parse_xpath('foo').should == s(:xpath, s(:node_test, s(:name, nil, 'foo')))
    end

    example 'parse an expression using two paths' do
      parse_xpath('/foo/bar').should == s(
        :xpath,
        s(:path, s(:node_test, s(:name, nil, 'foo'))),
        s(:path, s(:node_test, s(:name, nil, 'bar')))
      )
    end
  end
end
