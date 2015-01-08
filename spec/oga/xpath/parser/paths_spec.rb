require 'spec_helper'

describe Oga::XPath::Parser do
  describe 'paths' do
    it 'parses an absolute path' do
      parse_xpath('/A').should == s(
        :absolute_path,
        s(:axis, 'child', s(:test, nil, 'A'))
      )
    end

    it 'parses a relative path' do
      parse_xpath('A').should == s(:axis, 'child', s(:test, nil, 'A'))
    end

    it 'parses an expression using two paths' do
      parse_xpath('/A/B').should == s(
        :absolute_path,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end

    it 'parses an absolute path without a node test' do
      parse_xpath('/').should == s(:absolute_path)
    end
  end
end
