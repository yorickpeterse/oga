require 'spec_helper'

describe Oga::Lexer do
  context 'cdata tags' do
    example 'lex a cdata tag' do
      lex('<![CDATA[foo]]>').should == [
        [:T_CDATA_START, nil, 1],
        [:T_TEXT, 'foo', 1],
        [:T_CDATA_END, nil, 1]
      ]
    end

    example 'lex tags inside CDATA tags as regular text' do
      lex('<![CDATA[<p>Foo</p>]]>').should == [
        [:T_CDATA_START, nil, 1],
        [:T_TEXT, '<p>Foo</p>', 1],
        [:T_CDATA_END, nil, 1]
      ]
    end

    example 'lex double brackets inside a CDATA tag' do
      lex('<![CDATA[]]]]>').should == [
        [:T_CDATA_START, nil, 1],
        [:T_TEXT, ']]', 1],
        [:T_CDATA_END, nil, 1]
      ]
    end
  end
end
