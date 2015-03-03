require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'HTML style elements' do
    it 'treats the content of a style tag as plain text' do
      lex('<style>foo <bar</style>', :html => true).should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'style', 1],
        [:T_TEXT, 'foo <bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
