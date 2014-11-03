require 'spec_helper'

describe Oga::CSS::Parser do
  context ':last-child pseudo class' do
    example 'parse the :last-child pseudo class' do
      parse_css(':last-child').should == parse_xpath(
        'descendant-or-self::*[count(following-sibling::*) = 0]'
      )
    end
  end
end
