require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'processing instructions' do
    it 'lexes a processing instruction' do
      lex('<?foo?>').should == [
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo', 1],
        [:T_PROC_INS_END, nil, 1]
      ]
    end

    it 'lexes a processing instruction containing text' do
      lex('<?foo bar ?>').should == [
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo', 1],
        [:T_TEXT, ' bar ', 1],
        [:T_PROC_INS_END, nil, 1]
      ]
    end
  end
end
