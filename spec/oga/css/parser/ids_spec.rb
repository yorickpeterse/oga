require 'spec_helper'

describe Oga::CSS::Parser do
  context 'IDs' do
    example 'parse an ID selector' do
      parse_css('#foo').should == s(:id, nil, 'foo')
    end

    example 'parse a selector for an element with an ID' do
      parse_css('foo#bar').should == s(:id, s(:test, nil, 'foo'), 'bar')
    end

    example 'parse a selector using an ID and a class' do
      parse_css('.foo#bar').should == s(:id, s(:class, nil, 'foo'), 'bar')
    end

    example 'parse a selector using an ID and a pseudo class' do
      parse_css('#foo:root').should == s(:pseudo, s(:id, nil, 'foo'), 'root')
    end

    example 'parse a selector using a pseudo class and an ID' do
      parse_css('x:root#foo').should == s(
        :id,
        s(:pseudo, s(:test, nil, 'x'), 'root'),
        'foo'
      )
    end
  end
end
