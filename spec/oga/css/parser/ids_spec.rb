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
      parse_css('#foo:root').should == s(:pseudo, 'root', s(:id, nil, 'foo'))
    end

    example 'parse a selector using a pseudo class and an ID' do
      parse_css('x:root#foo').should == s(
        :id,
        s(:pseudo, 'root', s(:test, nil, 'x')),
        'foo'
      )
    end
  end
end
