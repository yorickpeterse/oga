require 'spec_helper'

describe Oga::CSS::Parser do
  context 'wildcards' do
    example 'parse a wildcard name test' do
      parse_css('*').should == parse_xpath('descendant-or-self::*')
    end

    example 'parse a wildcard namespace test' do
      parse_css('*|foo').should == parse_xpath('descendant-or-self::*:foo')
    end

    example 'parse a wildcard namespace and name test' do
      parse_css('*|*').should == parse_xpath('descendant-or-self::*:*')
    end
  end
end
