require 'spec_helper'

describe Oga::XPath::Parser do
  context 'wildcards' do
    example 'parse a wildcard name test' do
      parse_xpath('*').should == s(:test, nil, '*')
    end

    example 'parse a wildcard namespace test' do
      parse_xpath('*:A').should == s(:test, '*', 'A')
    end

    example 'parse a wildcard namespace and name test' do
      parse_xpath('*:*').should == s(:test, '*', '*')
    end
  end
end
