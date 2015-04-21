require 'spec_helper'

describe Oga::XML::Lexer do
  described_class::HTML_CLOSE_SELF.each do |element, terminals|
    describe "lexing <#{element}> tags" do
      terminals.each do |term|
        it "automatically closes a <#{element}> followed by a <#{term}>" do
          lex_html("<#{element}><#{term}>").should == [
            [:T_ELEM_NAME, element, 1],
            [:T_ELEM_END, nil, 1],
            [:T_ELEM_NAME, term, 1],
            [:T_ELEM_END, nil, 1]
          ]
        end
      end
    end
  end
end
