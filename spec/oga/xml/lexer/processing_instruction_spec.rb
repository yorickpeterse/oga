require 'spec_helper'

describe Oga::XML::Lexer do
  context 'processing instructions' do
    example 'lex a processing instruction' do
      lex('<?foo?>').should == [
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo', 1],
        [:T_PROC_INS_END, nil, 1]
      ]
    end

    example 'lex a processing instruction containing text' do
      lex('<?foo bar ?>').should == [
        [:T_PROC_INS_START, nil, 1],
        [:T_PROC_INS_NAME, 'foo', 1],
        [:T_TEXT, ' bar ', 1],
        [:T_PROC_INS_END, nil, 1]
      ]
    end
  end
end
