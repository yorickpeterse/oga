require 'spec_helper'

describe Oga::CSS::Parser do
  context ':first-of-type pseudo class' do
    example 'parse the :first-of-type pseudo class' do
      parse_css(':first-of-type').should == parse_xpath(
        'descendant::*[position() = 1]'
      )
    end
  end
end
