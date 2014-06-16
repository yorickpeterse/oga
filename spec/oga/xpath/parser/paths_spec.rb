require 'spec_helper'

describe Oga::XPath::Parser do
  context 'paths' do
    example 'parse an absolute path' do
      parse_xpath('/A').should == s(:absolute, s(:test, s(:name, nil, 'A')))
    end

    example 'parse a relative path' do
      parse_xpath('A').should == s(:test, s(:name, nil, 'A'))
    end

    example 'parse an expression using two paths' do
      parse_xpath('/A/B').should == s(
        :absolute,
        s(:test, s(:name, nil, 'A'), s(:test, s(:name, nil, 'B')))
      )
    end
  end
end
