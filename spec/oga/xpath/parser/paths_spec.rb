require 'spec_helper'

describe Oga::XPath::Parser do
  context 'paths' do
    example 'parse an absolute path' do
      parse_xpath('/A').should == s(
        :absolute_path,
        s(:axis, 'child', s(:test, nil, 'A'))
      )
    end

    example 'parse a relative path' do
      parse_xpath('A').should == s(:axis, 'child', s(:test, nil, 'A'))
    end

    example 'parse an expression using two paths' do
      parse_xpath('/A/B').should == s(
        :absolute_path,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(:axis, 'child', s(:test, nil, 'B'))
      )
    end
  end
end
