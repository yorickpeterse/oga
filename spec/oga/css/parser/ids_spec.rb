require 'spec_helper'

describe Oga::CSS::Parser do
  context 'IDs' do
    example 'parse an ID selector' do
      parse_css('#foo').should == s(:id, 'foo')
    end

    example 'parse a selector for an element with an ID' do
      parse_css('foo#bar').should == s(:id, 'bar', s(:test, nil, 'foo'))
    end

    example 'parse a selector using an ID and a class' do
      parse_css('.foo#bar').should == s(:id, 'bar', s(:class, 'foo'))
    end

    example 'parse a selector using an ID and a pseudo class' do
      parse_css('#foo:root').should == s(:pseudo, 'root', s(:id, 'foo'))
    end

    example 'parse a selector using a pseudo class and an ID' do
      parse_css('x:root#foo').should == s(
        :id,
        'foo',
        s(:pseudo, 'root', s(:test, nil, 'x'))
      )
    end
  end
end
