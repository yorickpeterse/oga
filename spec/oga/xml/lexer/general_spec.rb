require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'regular text' do
    it 'lexes regular text' do
      lex('hello').should == [[:T_TEXT, 'hello', 1]]
    end

    it 'lexes regular whitespace' do
      lex(' ').should == [[:T_TEXT, ' ', 1]]
    end

    it 'lexes a newline' do
      lex("\n").should == [[:T_TEXT, "\n", 1]]
    end

    it 'lexes text followed by a newline' do
      lex("foo\n").should == [[:T_TEXT, "foo\n", 1]]
    end

    it 'lexes a > as regular text' do
      lex('>').should == [[:T_TEXT, '>', 1]]
    end

    it 'lexes </ as regular text' do
      lex('</').should == [[:T_TEXT, '</', 1]]
    end

    it 'lexes <! as regular text' do
      lex('<!').should == [[:T_TEXT, '<!', 1]]
    end

    it 'lexes <? as regular text' do
      lex('<?').should == [[:T_TEXT, '<?', 1]]
    end
  end
end
