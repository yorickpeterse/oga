require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'regular text' do
    it 'lexes regular text' do
      expect(lex('hello')).to eq([[:T_TEXT, 'hello', 1]])
    end

    it 'lexes regular whitespace' do
      expect(lex(' ')).to eq([[:T_TEXT, ' ', 1]])
    end

    it 'lexes a Unix newline' do
      expect(lex("\n")).to eq([[:T_TEXT, "\n", 1]])
    end

    it 'lexes a Windows newline' do
      expect(lex("\r\n")).to eq([[:T_TEXT, "\r\n", 1]])
    end

    it 'lexes a carriage return' do
      expect(lex("\r")).to eq([[:T_TEXT, "\r", 1]])
    end

    it 'lexes text followed by a newline' do
      expect(lex("foo\n")).to eq([[:T_TEXT, "foo\n", 1]])
    end

    it 'lexes a > as regular text' do
      expect(lex('>')).to eq([[:T_TEXT, '>', 1]])
    end

    it 'lexes <! as regular text' do
      expect(lex('<!')).to eq([[:T_TEXT, '<!', 1]])
    end

    it 'lexes <? as regular text' do
      expect(lex('<?')).to eq([[:T_TEXT, '<?', 1]])
    end
  end
end
