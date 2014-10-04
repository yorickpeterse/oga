require 'spec_helper'

describe Oga::CSS::Parser do
  context 'paths' do
    example 'parse a single path' do
      parse_css('foo').should == s(:test, nil, 'foo')
    end

    example 'parse a path using two selectors' do
      parse_css('foo bar').should == s(
        :path,
        s(:test, nil, 'foo'),
        s(:test, nil, 'bar')
      )
    end
  end
end
