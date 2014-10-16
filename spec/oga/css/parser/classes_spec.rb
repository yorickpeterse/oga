require 'spec_helper'

describe Oga::CSS::Parser do
  context 'classes' do
    example 'parse a class selector' do
      parse_css('.foo').should == s(:class, nil, 'foo')
    end

    example 'parse a selector for an element with a class' do
      parse_css('foo.bar').should == s(:class, s(:test, nil, 'foo'), 'bar')
    end

    example 'parse a selector using multiple classes' do
      parse_css('.foo.bar').should == s(:class, s(:class, nil, 'foo'), 'bar')
    end

    example 'parse a selector using a class and an ID' do
      parse_css('#foo.bar').should == s(:class, s(:id, nil, 'foo'), 'bar')
    end

    example 'parse a selector using a class and a pseudo class' do
      parse_css('.foo:root').should == s(:pseudo, s(:class, nil, 'foo'), 'root')
    end

    example 'parse a selector using a pseudo class and a class' do
      parse_css('x:root.foo').should == s(
        :class,
        s(:pseudo, s(:test, nil, 'x'), 'root'),
        'foo'
      )
    end
  end
end
