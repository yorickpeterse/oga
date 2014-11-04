require 'spec_helper'

describe Oga::CSS::Parser do
  context 'wildcards' do
    example 'parse a wildcard name test' do
      parse_css('*').should == parse_xpath('descendant::*')
    end

    example 'parse a wildcard namespace test' do
      parse_css('*|foo').should == parse_xpath('descendant::*:foo')
    end

    example 'parse a wildcard namespace and name test' do
      parse_css('*|*').should == parse_xpath('descendant::*:*')
    end
  end
end
