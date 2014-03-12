require 'spec_helper'

describe Oga::Parser do
  example 'parse regular text' do
    parse_html('foo').should == s(:document, s(:text, 'foo'))
  end
end
