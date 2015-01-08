require 'spec_helper'

describe Oga::CSS::Parser do
  describe 'wildcards' do
    it 'parses a wildcard name test' do
      parse_css('*').should == parse_xpath('descendant::*')
    end

    it 'parses a wildcard namespace test' do
      parse_css('*|foo').should == parse_xpath('descendant::*:foo')
    end

    it 'parses a wildcard namespace and name test' do
      parse_css('*|*').should == parse_xpath('descendant::*:*')
    end
  end
end
