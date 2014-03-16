require 'spec_helper'

describe Oga::Parser do
  context 'doctypes' do
    example 'parse a doctype' do
      parse('<!DOCTYPE html>').should == s(:document, s(:doctype))
    end

    example 'parse a doctype with the doctype type' do
      parse('<!DOCTYPE html PUBLIC>').should == s(
        :document,
        s(:doctype, 'PUBLIC')
      )
    end

    example 'parse a doctype with a public ID' do
      parse('<!DOCTYPE html PUBLIC "foo">').should == s(
        :document,
        s(:doctype, 'PUBLIC', 'foo')
      )
    end

    example 'parse a doctype with a public and private ID' do
      parse('<!DOCTYPE html PUBLIC "foo" "bar">').should == s(
        :document,
        s(:doctype, 'PUBLIC', 'foo', 'bar')
      )
    end

    example 'parse an HTML 4 strict doctype' do
      doctype = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" ' \
        '"http://www.w3.org/TR/html4/strict.dtd">'

      parse(doctype).should == s(
        :document,
        s(
          :doctype,
          'PUBLIC',
          '-//W3C//DTD HTML 4.01//EN',
          'http://www.w3.org/TR/html4/strict.dtd'
        )
      )
    end
  end
end
