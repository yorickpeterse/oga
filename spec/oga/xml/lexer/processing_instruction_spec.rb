require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'processing instructions' do
    it 'lexes an instruction' do
      expect(lex('<?foo?>')).to eq([
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo', 1],
        [:T_PROC_INS_END, nil, 1]
      ])
    end

    it 'lexes an instruction containing text' do
      expect(lex('<?foo bar ?>')).to eq([
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo', 1],
        [:T_PROC_INS_BODY, ' bar ', 1],
        [:T_PROC_INS_END, nil, 1]
      ])
    end

    it 'lexes an instruction containing a ?' do
      expect(lex('<?foo ? ?>')).to eq([
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo', 1],
        [:T_PROC_INS_BODY, ' ', 1],
        [:T_PROC_INS_BODY, '?', 1],
        [:T_PROC_INS_BODY, ' ', 1],
        [:T_PROC_INS_END, nil, 1]
      ])
    end

    it 'lexes two instructions following each other' do
      expect(lex('<?foo bar ?><?foo baz ?>')).to eq([
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo', 1],
        [:T_PROC_INS_BODY, ' bar ', 1],
        [:T_PROC_INS_END, nil, 1],
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo', 1],
        [:T_PROC_INS_BODY, ' baz ', 1],
        [:T_PROC_INS_END, nil, 1]
      ])
    end

    it 'lexes an instruction with a newline after the name' do
      expect(lex("<?foo\nbar?>")).to eq([
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo', 1],
        [:T_PROC_INS_BODY, "\nbar", 1],
        [:T_PROC_INS_END, nil, 2]
      ])
    end

    it 'lexes an instruction with a newline before the closing tag' do
      expect(lex("<?foo bar\n?>")).to eq([
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo', 1],
        [:T_PROC_INS_BODY, " bar\n", 1],
        [:T_PROC_INS_END, nil, 2]
      ])
    end

    it 'lexes an instruction with the body surrounded by newlines' do
      expect(lex("<?foo\nbar\n?>")).to eq([
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo', 1],
        [:T_PROC_INS_BODY, "\nbar\n", 1],
        [:T_PROC_INS_END, nil, 3]
      ])
    end

    it 'lexes an instruction with a namespace prefix' do
      expect(lex('<?foo:bar?>')).to eq([
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo:bar', 1],
        [:T_PROC_INS_END, nil, 1]
      ])
    end

    describe 'using an IO as input' do
      it 'lexes an instruction with a newline after the name' do
        expect(lex_stringio("<?foo\nbar?>")).to eq([
          [:T_PROC_INS_START, nil, 1],
          [:T_PROC_INS_NAME, 'foo', 1],
          [:T_PROC_INS_BODY, "\n", 1],
          [:T_PROC_INS_BODY, "bar", 2],
          [:T_PROC_INS_END, nil, 2]
        ])
      end

      it 'lexes an instruction with a newline before the closing tag' do
        expect(lex_stringio("<?foo bar\n?>")).to eq([
          [:T_PROC_INS_START, nil, 1],
          [:T_PROC_INS_NAME, 'foo', 1],
          [:T_PROC_INS_BODY, " bar\n", 1],
          [:T_PROC_INS_END, nil, 2]
        ])
      end

      it 'lexes an instruction with the body surrounded by newlines' do
        expect(lex_stringio("<?foo\nbar\n?>")).to eq([
          [:T_PROC_INS_START, nil, 1],
          [:T_PROC_INS_NAME, 'foo', 1],
          [:T_PROC_INS_BODY, "\n", 1],
          [:T_PROC_INS_BODY, "bar\n", 2],
          [:T_PROC_INS_END, nil, 3]
        ])
      end
    end
  end
end
