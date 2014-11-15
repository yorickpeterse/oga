require 'spec_helper'

describe Oga::CSS::Parser do
  context ':last-of-type pseudo class' do
    example 'parse the :last-of-type pseudo class' do
      parse_css(':last-of-type').should == parse_xpath(
        'descendant::*[count(following-sibling::*) = 0]'
      )
    end

    example 'parse the a:last-of-type pseudo class' do
      parse_css('a:last-of-type').should == parse_xpath(
        'descendant::a[count(following-sibling::a) = 0]'
      )
    end
  end
end
