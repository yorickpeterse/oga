require 'spec_helper'

describe Oga::CSS::Parser do
  context ':only-child pseudo class' do
    example 'parse the :only-child pseudo class' do
      parse_css(':only-child').should == parse_xpath(
        'descendant::*[count(preceding-sibling::*) = 0 ' \
          'and count(following-sibling::*) = 0]'
      )
    end
  end
end
