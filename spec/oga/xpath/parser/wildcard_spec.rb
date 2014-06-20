require 'spec_helper'

describe Oga::XPath::Parser do
  context 'wildcards' do
    example 'parse a wildcard name test' do
      parse_xpath('*').should == s(:path, s(:test, nil, '*'))
    end

    example 'parse a wildcard namespace test' do
      parse_xpath('*:A').should == s(:path, s(:test, '*', 'A'))
    end

    example 'parse a wildcard namespace and name test' do
      parse_xpath('*:*').should == s(:path, s(:test, '*', '*'))
    end
  end
end
