require 'spec_helper'

describe Oga::XML::Lexer do
  context 'cdata tags' do
    example 'lex a cdata tag' do
      lex('<![CDATA[foo]]>').should == [[:T_CDATA, 'foo', 1]]
    end

    example 'lex tags inside CDATA tags as regular text' do
      lex('<![CDATA[<p>Foo</p>]]>').should == [[:T_CDATA, '<p>Foo</p>', 1]]
    end

    example 'lex double brackets inside a CDATA tag' do
      lex('<![CDATA[]]]]>').should == [[:T_CDATA, ']]', 1]]
    end

    example 'lex two CDATA tags following each other' do
      lex('<a><![CDATA[foo]]><b><![CDATA[bar]]></b></a>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'a', 1],
        [:T_CDATA, 'foo', 1],
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'b', 1],
        [:T_CDATA, 'bar', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
