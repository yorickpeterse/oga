require 'spec_helper'

describe Oga::Parser do
  context 'comments' do
    example 'parse an empty comment' do
      parse_html('<!---->').should == s(:document, s(:comment))
    end

    example 'parse a comment' do
      parse_html('<!--foo-->').should == s(:document, s(:comment, 'foo'))
    end
  end
end
