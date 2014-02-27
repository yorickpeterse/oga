require 'spec_helper'

describe Oga::Lexer do
  context 'doctypes' do
    example 'lex the HTML5 doctype' do
      lex('<!DOCTYPE html>').should == [
        [:T_DOCTYPE, '<!DOCTYPE html>', 1, 1]
      ]
    end

    example 'lex a random doctype' do
      lex('<!DOCTYPE HTML PUBLIC "foobar" "baz">').should == [
        [:T_DOCTYPE, '<!DOCTYPE HTML PUBLIC "foobar" "baz">', 1, 1]
      ]
    end
  end
end
