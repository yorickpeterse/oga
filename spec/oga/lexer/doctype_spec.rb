require 'spec_helper'

describe Oga::Lexer do
  context 'doctypes' do
    example 'lex the HTML5 doctype' do
      lex('<!DOCTYPE html>').should == [
        [:T_DOCTYPE_START, '<!DOCTYPE html', 1, 1],
        [:T_DOCTYPE_END, '>', 1, 15]
      ]
    end

    example 'lex a doctype with a public and system ID' do
      lex('<!DOCTYPE HTML PUBLIC "foobar" "baz">').should == [
        [:T_DOCTYPE_START, '<!DOCTYPE HTML', 1, 1],
        [:T_DOCTYPE_TYPE, 'PUBLIC', 1, 16],
        [:T_STRING, 'foobar', 1, 24],
        [:T_STRING, 'baz', 1, 33],
        [:T_DOCTYPE_END, '>', 1, 37]
      ]
    end

    example 'lex a doctype with a public and system ID using single quotes' do
      lex("<!DOCTYPE HTML PUBLIC 'foobar' 'baz'>").should == [
        [:T_DOCTYPE_START, '<!DOCTYPE HTML', 1, 1],
        [:T_DOCTYPE_TYPE, 'PUBLIC', 1, 16],
        [:T_STRING, 'foobar', 1, 24],
        [:T_STRING, 'baz', 1, 33],
        [:T_DOCTYPE_END, '>', 1, 37]
      ]
    end
  end
end
