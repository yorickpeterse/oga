require 'spec_helper'

describe Oga::CSS::Parser do
  context 'wildcards' do
    example 'parse a wildcard name test' do
      parse_css('*').should == s(:test, nil, '*')
    end

    example 'parse a wildcard namespace test' do
      parse_css('*|foo').should == s(:test, '*', 'foo')
    end

    example 'parse a wildcard namespace and name test' do
      parse_css('*|*').should == s(:test, '*', '*')
    end
  end
end
