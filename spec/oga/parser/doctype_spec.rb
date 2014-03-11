require 'spec_helper'

describe Oga::Parser do
  context 'doctypes' do
    example 'parse a doctype' do
      parse_html('<!DOCTYPE html>').should == s(:document, s(:doctype))
    end

    example 'parse a doctype with a public ID' do
      parse_html('<!DOCTYPE html "foo">').should == s(
        :document,
        s(:doctype, 'foo')
      )
    end

    example 'parse a doctype with a public and private ID' do
      parse_html('<!DOCTYPE html "foo" "bar">').should == s(
        :document,
        s(:doctype, 'foo', 'bar')
      )
    end

    example 'parse an HTML 4 strict doctype' do
      doctype = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" ' \
        '"http://www.w3.org/TR/html4/strict.dtd">'

      parse_html(doctype).should == s(
        :document,
        s(
          :doctype,
          '-//W3C//DTD HTML 4.01//EN',
          'http://www.w3.org/TR/html4/strict.dtd'
        )
      )
    end
  end
end
