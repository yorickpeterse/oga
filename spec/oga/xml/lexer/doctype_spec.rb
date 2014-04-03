require 'spec_helper'

describe Oga::XML::Lexer do
  context 'doctypes' do
    example 'lex the HTML5 doctype' do
      lex('<!DOCTYPE html>').should == [
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'html', 1],
        [:T_DOCTYPE_END, nil, 1]
      ]
    end

    example 'lex a doctype with a public and system ID' do
      lex('<!DOCTYPE HTML PUBLIC "foobar" "baz">').should == [
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'HTML', 1],
        [:T_DOCTYPE_TYPE, 'PUBLIC', 1],
        [:T_STRING, 'foobar', 1],
        [:T_STRING, 'baz', 1],
        [:T_DOCTYPE_END, nil, 1]
      ]
    end

    example 'lex a doctype with a public and system ID using single quotes' do
      lex("<!DOCTYPE HTML PUBLIC 'foobar' 'baz'>").should == [
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'HTML', 1],
        [:T_DOCTYPE_TYPE, 'PUBLIC', 1],
        [:T_STRING, 'foobar', 1],
        [:T_STRING, 'baz', 1],
        [:T_DOCTYPE_END, nil, 1]
      ]
    end
  end
end
