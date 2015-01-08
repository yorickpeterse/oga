require 'spec_helper'

describe Oga::CSS::Parser do
  describe ':first-of-type pseudo class' do
    it 'parses the :first-of-type pseudo class' do
      parse_css(':first-of-type').should == parse_xpath(
        'descendant::*[count(preceding-sibling::*) = 0]'
      )
    end

    it 'parses the a:first-of-type pseudo class' do
      parse_css('a:first-of-type').should == parse_xpath(
        'descendant::a[count(preceding-sibling::a) = 0]'
      )
    end
  end
end
