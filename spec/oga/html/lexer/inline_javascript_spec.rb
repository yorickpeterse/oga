require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'lexing inline Javascript' do
    before do
      @javascript = 'if ( number < 10 ) { }'
    end

    it 'lexes inline Javascript' do
      expect(lex("<script>#{@javascript}</script>")).to eq([
        [:T_ELEM_NAME, 'script', 1],
        [:T_TEXT, @javascript, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes inline Javascript containing an XML comment' do
      expect(lex("<script>#{@javascript}<!--foo--></script>")).to eq([
        [:T_ELEM_NAME, 'script', 1],
        [:T_TEXT, @javascript, 1],
        [:T_COMMENT_START, nil, 1],
        [:T_COMMENT_BODY, 'foo', 1],
        [:T_COMMENT_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes inline Javascript containing a CDATA tag' do
      expect(lex("<script>#{@javascript}<![CDATA[foo]]></script>")).to eq([
        [:T_ELEM_NAME, 'script', 1],
        [:T_TEXT, @javascript, 1],
        [:T_CDATA_START, nil, 1],
        [:T_CDATA_BODY, 'foo', 1],
        [:T_CDATA_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes inline Javascript containing a processing instruction' do
      expect(lex("<script>#{@javascript}<?foo?></script>")).to eq([
        [:T_ELEM_NAME, 'script', 1],
        [:T_TEXT, @javascript, 1],
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo', 1],
        [:T_PROC_INS_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes inline Javascript containing another element' do
      expect(lex("<script>#{@javascript}<p></p></script>")).to eq([
        [:T_ELEM_NAME, 'script', 1],
        [:T_TEXT, @javascript, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end
  end
end
