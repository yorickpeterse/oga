require 'spec_helper'

describe Oga::CSS::Parser do
  context ':only-of-type pseudo class' do
    example 'parse the :only-of-type pseudo class' do
      parse_css(':only-of-type').should == parse_xpath(
        'descendant::*[count(preceding-sibling::*) = 0 and ' \
          'count(following-sibling::*) = 0]'
      )
    end

    example 'parse the a:only-of-type pseudo class' do
      parse_css('a:only-of-type').should == parse_xpath(
        'descendant::a[count(preceding-sibling::a) = 0 and ' \
          'count(following-sibling::a) = 0]'
      )
    end
  end
end
