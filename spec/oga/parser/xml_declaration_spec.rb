require 'spec_helper'

describe Oga::Parser do
  context 'XML declaration tags' do
    example 'lex an XML declaration tag' do
      parse('<?xml hello ?>').should == s(
        :document,
        s(:xml_decl, s(:text, ' hello '))
      )
    end
  end
end
