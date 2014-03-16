require 'spec_helper'

describe Oga::Lexer do
  context 'HTML void elements' do
    example 'lex a void element that omits the closing /' do
      lex('<link>', :html => true).should == [
        [:T_ELEM_OPEN, nil, 1, 1],
        [:T_ELEM_NAME, 'link', 1, 2],
        [:T_ELEM_CLOSE, nil, 1, 6]
      ]
    end

    example 'lex text after a void element' do
      lex('<link>foo', :html => true).should == [
        [:T_ELEM_OPEN, nil, 1, 1],
        [:T_ELEM_NAME, 'link', 1, 2],
        [:T_ELEM_CLOSE, nil, 1, 6],
        [:T_TEXT, 'foo', 1, 7]
      ]
    end

    example 'lex a void element inside another element' do
      lex('<head><link></head>', :html => true).should == [
        [:T_ELEM_OPEN, nil, 1, 1],
        [:T_ELEM_NAME, 'head', 1, 2],
        [:T_ELEM_OPEN, nil, 1, 7],
        [:T_ELEM_NAME, 'link', 1, 8],
        [:T_ELEM_CLOSE, nil, 1, 12],
        [:T_ELEM_CLOSE, nil, 1, 13]
      ]
    end

    example 'lex a void element inside another element with whitespace' do
      lex("<head><link>\n</head>", :html => true).should == [
        [:T_ELEM_OPEN, nil, 1, 1],
        [:T_ELEM_NAME, 'head', 1, 2],
        [:T_ELEM_OPEN, nil, 1, 7],
        [:T_ELEM_NAME, 'link', 1, 8],
        [:T_ELEM_CLOSE, nil, 1, 12],
        [:T_TEXT, "\n", 1, 13],
        [:T_ELEM_CLOSE, nil, 2, 1]
      ]
    end
  end
end
