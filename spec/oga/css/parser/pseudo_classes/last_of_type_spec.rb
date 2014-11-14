require 'spec_helper'

describe Oga::CSS::Parser do
  context ':last-of-type pseudo class' do
    example 'parse the :last-of-type pseudo class' do
      parse_css(':last-of-type').should == parse_xpath(
        'descendant::*[count(following-sibling::name()) = 0]'
      )
    end
  end
end
