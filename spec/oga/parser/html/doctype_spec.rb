require 'spec_helper'

describe Oga::Parser::HTML do
  context 'doctypes' do
    example 'parse the HTML5 doctype' do
      doctype = '<!DOCTYPE html>'

      parse_html(doctype).should == s( :document, s(:doctype, doctype))
    end

    example 'parse an HTML 4 strict doctype' do
      doctype = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" ' \
        '"http://www.w3.org/TR/html4/strict.dtd">'

      parse_html(doctype).should == s(:document, s(:doctype, doctype))
    end
  end
end
