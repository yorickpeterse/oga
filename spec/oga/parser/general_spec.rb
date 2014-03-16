require 'spec_helper'

describe Oga::Parser do
  example 'parse regular text' do
    parse('foo').should == s(:document, s(:text, 'foo'))
  end

  example 'parse a newline' do
    parse("\n").should == s(:document, s(:text, "\n"))
  end
end
