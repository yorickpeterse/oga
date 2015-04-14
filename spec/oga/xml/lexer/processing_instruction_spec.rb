require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'processing instructions' do
    it 'lexes an instruction' do
      lex('<?foo?>').should == [
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo', 1],
        [:T_PROC_INS_END, nil, 1]
      ]
    end

    it 'lexes an instruction containing text' do
      lex('<?foo bar ?>').should == [
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo', 1],
        [:T_PROC_INS_BODY, ' bar ', 1],
        [:T_PROC_INS_END, nil, 1]
      ]
    end

    it 'lexes an instruction containing a ?' do
      lex('<?foo ? ?>').should == [
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo', 1],
        [:T_PROC_INS_BODY, ' ', 1],
        [:T_PROC_INS_BODY, '?', 1],
        [:T_PROC_INS_BODY, ' ', 1],
        [:T_PROC_INS_END, nil, 1]
      ]
    end

    it 'lexes two instructions following each other' do
      lex('<?foo bar ?><?foo baz ?>').should == [
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo', 1],
        [:T_PROC_INS_BODY, ' bar ', 1],
        [:T_PROC_INS_END, nil, 1],
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo', 1],
        [:T_PROC_INS_BODY, ' baz ', 1],
        [:T_PROC_INS_END, nil, 1]
      ]
    end

    it 'lexes an instruction with a newline after the name' do
      lex("<?foo\nbar?>").should == [
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo', 1],
        [:T_PROC_INS_BODY, "\nbar", 1],
        [:T_PROC_INS_END, nil, 2]
      ]
    end

    it 'lexes an instruction with a newline before the closing tag' do
      lex("<?foo bar\n?>").should == [
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo', 1],
        [:T_PROC_INS_BODY, " bar\n", 1],
        [:T_PROC_INS_END, nil, 2]
      ]
    end

    it 'lexes an instruction with the body surrounded by newlines' do
      lex("<?foo\nbar\n?>").should == [
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo', 1],
        [:T_PROC_INS_BODY, "\nbar\n", 1],
        [:T_PROC_INS_END, nil, 3]
      ]
    end

    describe 'using an IO as input' do
      it 'lexes an instruction with a newline after the name' do
        lex_stringio("<?foo\nbar?>").should == [
          [:T_PROC_INS_START, nil, 1],
          [:T_PROC_INS_NAME, 'foo', 1],
          [:T_PROC_INS_BODY, "\n", 1],
          [:T_PROC_INS_BODY, "bar", 2],
          [:T_PROC_INS_END, nil, 2]
        ]
      end

      it 'lexes an instruction with a newline before the closing tag' do
        lex_stringio("<?foo bar\n?>").should == [
          [:T_PROC_INS_START, nil, 1],
          [:T_PROC_INS_NAME, 'foo', 1],
          [:T_PROC_INS_BODY, " bar\n", 1],
          [:T_PROC_INS_END, nil, 2]
        ]
      end

      it 'lexes an instruction with the body surrounded by newlines' do
        lex_stringio("<?foo\nbar\n?>").should == [
          [:T_PROC_INS_START, nil, 1],
          [:T_PROC_INS_NAME, 'foo', 1],
          [:T_PROC_INS_BODY, "\n", 1],
          [:T_PROC_INS_BODY, "bar\n", 2],
          [:T_PROC_INS_END, nil, 3]
        ]
      end
    end
  end
end
