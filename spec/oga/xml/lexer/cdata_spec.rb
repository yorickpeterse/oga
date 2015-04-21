require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'CDATA tags' do
    it 'lexes a CDATA tag' do
      lex('<![CDATA[foo]]>').should == [
        [:T_CDATA_START, nil, 1],
        [:T_CDATA_BODY, 'foo', 1],
        [:T_CDATA_END, nil, 1]
      ]
    end

    it 'lexes tags inside CDATA tags as regular text' do
      lex('<![CDATA[<p>Foo</p>]]>').should == [
        [:T_CDATA_START, nil, 1],
        [:T_CDATA_BODY, '<p>Foo</p>', 1],
        [:T_CDATA_END, nil, 1]
      ]
    end

    it 'lexes a single bracket inside a CDATA tag' do
      lex('<![CDATA[]]]>').should == [
        [:T_CDATA_START, nil, 1],
        [:T_CDATA_BODY, ']', 1],
        [:T_CDATA_END, nil, 1]
      ]
    end

    it 'lexes double brackets inside a CDATA tag' do
      lex('<![CDATA[]]]]>').should == [
        [:T_CDATA_START, nil, 1],
        [:T_CDATA_BODY, ']', 1],
        [:T_CDATA_BODY, ']', 1],
        [:T_CDATA_END, nil, 1]
      ]
    end

    it 'lexes two CDATA tags following each other' do
      lex('<a><![CDATA[foo]]><b><![CDATA[bar]]></b></a>').should == [
        [:T_ELEM_NAME, 'a', 1],
        [:T_CDATA_START, nil, 1],
        [:T_CDATA_BODY, 'foo', 1],
        [:T_CDATA_END, nil, 1],
        [:T_ELEM_NAME, 'b', 1],
        [:T_CDATA_START, nil, 1],
        [:T_CDATA_BODY, 'bar', 1],
        [:T_CDATA_END, nil, 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes a CDATA tag containing a newline after the open tag' do
      lex("<![CDATA[\nfoo]]>").should == [
        [:T_CDATA_START, nil, 1],
        [:T_CDATA_BODY, "\nfoo", 1],
        [:T_CDATA_END, nil, 2]
      ]
    end

    it 'lexes a CDATA tag containing a newline before the closing tag' do
      lex("<![CDATA[foo\n]]>").should == [
        [:T_CDATA_START, nil, 1],
        [:T_CDATA_BODY, "foo\n", 1],
        [:T_CDATA_END, nil, 2]
      ]
    end

    it 'lexes a CDATA tag with the body surrounded by newlines' do
      lex("<![CDATA[\nfoo\n]]>").should == [
        [:T_CDATA_START, nil, 1],
        [:T_CDATA_BODY, "\nfoo\n", 1],
        [:T_CDATA_END, nil, 3]
      ]
    end

    describe 'using an IO as input' do
      it 'lexes a CDATA tag containing a newline after the open tag' do
        lex_stringio("<![CDATA[\nfoo]]>").should == [
          [:T_CDATA_START, nil, 1],
          [:T_CDATA_BODY, "\n", 1],
          [:T_CDATA_BODY, "foo", 2],
          [:T_CDATA_END, nil, 2]
        ]
      end

      it 'lexes a CDATA tag containing a newline before the closing tag' do
        lex_stringio("<![CDATA[foo\n]]>").should == [
          [:T_CDATA_START, nil, 1],
          [:T_CDATA_BODY, "foo\n", 1],
          [:T_CDATA_END, nil, 2]
        ]
      end

      it 'lexes a CDATA tag with the body surrounded by newlines' do
        lex_stringio("<![CDATA[\nfoo\n]]>").should == [
          [:T_CDATA_START, nil, 1],
          [:T_CDATA_BODY, "\n", 1],
          [:T_CDATA_BODY, "foo\n", 2],
          [:T_CDATA_END, nil, 3]
        ]
      end
    end
  end
end
