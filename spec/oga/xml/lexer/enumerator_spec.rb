require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'Enumerator as input' do
    before do
      @enum = Enumerator.new do |yielder|
        yielder << '<p>foo'
        yielder << '</p>'
      end
    end

    it 'lexes a paragraph element' do
      lex(@enum).should == [
        [:T_ELEM_NAME, 'p', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'rewinds input when resetting the lexer' do
      lexer = described_class.new(@enum)

      lexer.lex.empty?.should == false
      lexer.lex.empty?.should == false
    end
  end
end
