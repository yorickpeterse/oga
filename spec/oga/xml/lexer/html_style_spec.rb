require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'HTML style elements' do
    it 'lexes an empty <style> tag' do
      lex('<style></style>', :html => true).should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'style', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'treats the content of a style tag as plain text' do
      lex('<style>foo <bar</style>', :html => true).should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'style', 1],
        [:T_TEXT, 'foo <bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes a multi-line <style> tag using a String as the input' do
      lex("<style>foo\nbar</style>", :html => true).should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'style', 1],
        [:T_TEXT, "foo\nbar", 1],
        [:T_ELEM_END, nil, 2]
      ]
    end

    it 'lexes a multi-line <style> tag using an IO as the input' do
      io = StringIO.new("<style>foo\nbar</style>")

      lex(io, :html => true).should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'style', 1],
        [:T_TEXT, "foo\n", 1],
        [:T_TEXT, 'bar', 2],
        [:T_ELEM_END, nil, 2]
      ]
    end
  end
end
