require 'spec_helper'

describe Oga::HTML::Parser do
  example 'parse an HTML void element' do
    parse_html('<meta>').should == s(
      :document,
      s(:element, nil, 'meta', nil, nil)
    )
  end
end
