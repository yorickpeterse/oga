require 'spec_helper'

describe Oga::CSS::Parser do
  context 'classes' do
    example 'parse a class selector' do
      parse_css('.foo').should == s(:class, 'foo')
    end

    example 'parse a selector for an element with a class' do
      parse_css('foo.bar').should == s(:class, 'bar', s(:test, nil, 'foo'))
    end

    example 'parse a selector using multiple classes' do
      parse_css('.foo.bar').should == s(:class, 'bar', s(:class, 'foo'))
    end

    example 'parse a selector using a class and an ID' do
      parse_css('#foo.bar').should == s(:class, 'bar', s(:id, 'foo'))
    end
  end
end
