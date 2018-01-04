require 'spec_helper'

describe Oga::CSS::Lexer do
  it 'ignores leading and trailing whitespace' do
    expect(lex_css(' foo ')).to eq([[:T_IDENT, 'foo']])
  end
end
