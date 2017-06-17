require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'HTML void elements' do
    it 'lexes a void element that omits the closing /' do
      expect(lex_html('<link>')).to eq([
        [:T_ELEM_NAME, 'link', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a upper case void element' do
      expect(lex_html('<BR>')).to eq([
        [:T_ELEM_NAME, "BR", 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes text after a void element' do
      expect(lex_html('<link>foo')).to eq([
        [:T_ELEM_NAME, 'link', 1],
        [:T_ELEM_END, nil, 1],
        [:T_TEXT, 'foo', 1]
      ])
    end

    it 'lexes a void element inside another element' do
      expect(lex_html('<head><link></head>')).to eq([
        [:T_ELEM_NAME, 'head', 1],
        [:T_ELEM_NAME, 'link', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a void element inside another element with whitespace' do
      expect(lex_html("<head><link>\n</head>")).to eq([
        [:T_ELEM_NAME, 'head', 1],
        [:T_ELEM_NAME, 'link', 1],
        [:T_ELEM_END, nil, 1],
        [:T_TEXT, "\n", 1],
        [:T_ELEM_END, nil, 2]
      ])
    end

    it 'lexes a void element with an unquoted attribute value' do
      expect(lex_html('<br class=foo />')).to eq([
        [:T_ELEM_NAME, 'br', 1],
        [:T_ATTR, 'class', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, 'foo', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    describe 'without a space before the closing tag' do
      it 'lexes a void element' do
        expect(lex_html('<br/>')).to eq([
          [:T_ELEM_NAME, 'br', 1],
          [:T_ELEM_END, nil, 1]
        ])
      end

      it 'lexes a void element with an attribute' do
        expect(lex_html('<br class="foo"/>')).to eq([
          [:T_ELEM_NAME, 'br', 1],
          [:T_ATTR, 'class', 1],
          [:T_STRING_DQUOTE, nil, 1],
          [:T_STRING_BODY, 'foo', 1],
          [:T_STRING_DQUOTE, nil, 1],
          [:T_ELEM_END, nil, 1]
        ])
      end

      it 'lexes a void element with an unquoted attribute value' do
        expect(lex_html('<br class=foo/>')).to eq([
          [:T_ELEM_NAME, 'br', 1],
          [:T_ATTR, 'class', 1],
          [:T_STRING_SQUOTE, nil, 1],
          [:T_STRING_BODY, 'foo/', 1],
          [:T_STRING_SQUOTE, nil, 1],
          [:T_ELEM_END, nil, 1]
        ])
      end
    end
  end
end
