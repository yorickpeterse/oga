require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'HTML script elements' do
    it 'treats the content of a script tag as plain text' do
      lex('<script>foo <bar</script>', :html => true).should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'script', 1],
        [:T_TEXT, 'foo <bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
