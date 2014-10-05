require 'spec_helper'

describe Oga::CSS::Parser do
  context 'operators' do
    example 'parse the = operator' do
      parse_css('x[a="b"]').should == s(
        :test,
        nil,
        'x',
        s(:eq, s(:test, nil, 'a'), s(:string, 'b'))
      )
    end

    example 'parse the ~= operator' do
      parse_css('x[a~="b"]').should == s(
        :test,
        nil,
        'x',
        s(:space_in, s(:test, nil, 'a'), s(:string, 'b'))
      )
    end

    example 'parse the ^= operator' do
      parse_css('x[a^="b"]').should == s(
        :test,
        nil,
        'x',
        s(:starts_with, s(:test, nil, 'a'), s(:string, 'b'))
      )
    end

    example 'parse the $= operator' do
      parse_css('x[a$="b"]').should == s(
        :test,
        nil,
        'x',
        s(:ends_with, s(:test, nil, 'a'), s(:string, 'b'))
      )
    end

    example 'parse the *= operator' do
      parse_css('x[a*="b"]').should == s(
        :test,
        nil,
        'x',
        s(:in, s(:test, nil, 'a'), s(:string, 'b'))
      )
    end

    example 'parse the |= operator' do
      parse_css('x[a|="b"]').should == s(
        :test,
        nil,
        'x',
        s(:hyphen_in, s(:test, nil, 'a'), s(:string, 'b'))
      )
    end
  end
end
