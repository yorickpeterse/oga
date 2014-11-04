require 'spec_helper'

describe Oga::CSS::Parser do
  context ':only-of-type pseudo class' do
    example 'parse the :only-of-type pseudo class' do
      parse_css(':only-of-type').should == parse_xpath(
        'descendant::*[last() = 1]'
      )
    end
  end
end
