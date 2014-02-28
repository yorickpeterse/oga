require 'spec_helper'

describe Oga::Lexer do
  context 'cdata tags' do
    example 'lex a cdata tag' do
      lex('<![CDATA[foo]]>').should == [
        [:T_CDATA_START, '<![CDATA[', 1, 1],
        [:T_TEXT, 'foo', 1, 10],
        [:T_CDATA_END, ']]>', 1, 13]
      ]
    end

    example 'lex tags inside CDATA tags as regular text' do
      lex('<![CDATA[<p>Foo</p>]]>').should == [
        [:T_CDATA_START, '<![CDATA[', 1, 1],
        [:T_TEXT, '<p>Foo</p>', 1, 10],
        [:T_CDATA_END, ']]>', 1, 20]
      ]
    end

    example 'lex double brackets inside a CDATA tag' do
      lex('<![CDATA[]]]]>').should == [
        [:T_CDATA_START, '<![CDATA[', 1, 1],
        [:T_TEXT, ']]', 1, 10],
        [:T_CDATA_END, ']]>', 1, 12]
      ]
    end
  end
end
