require 'spec_helper'

describe Oga::CSS::Parser do
  context ':first-child pseudo class' do
    example 'parse the :first-child pseudo class' do
      parse_css(':first-child').should == parse_xpath(
        'descendant::*[count(preceding-sibling::*) = 0]'
      )
    end
  end
end
