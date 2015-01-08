require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'converting XML entities in text tokens' do
    it 'converts &amp; into &' do
      lex('&amp;').should == [[:T_TEXT, '&', 1]]
    end

    it 'converts &lt; into <' do
      lex('&lt;').should == [[:T_TEXT, '<', 1]]
    end

    it 'converts &gt; into >' do
      lex('&gt;').should == [[:T_TEXT, '>', 1]]
    end
  end

  describe 'converting XML entities in string tokens' do
    it 'converts &amp; into &' do
      lex('<foo class="&amp;" />').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'foo', 1],
        [:T_ATTR, 'class', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_BODY, '&', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'converts &lt; into <' do
      lex('<foo class="&lt;" />').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'foo', 1],
        [:T_ATTR, 'class', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_BODY, '<', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'converts &gt; into >' do
      lex('<foo class="&gt;" />').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'foo', 1],
        [:T_ATTR, 'class', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_BODY, '>', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
