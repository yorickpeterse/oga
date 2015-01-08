require 'spec_helper'

describe Oga::CSS::Parser do
  describe ':first-child pseudo class' do
    it 'parses the :first-child pseudo class' do
      parse_css(':first-child').should == parse_xpath(
        'descendant::*[count(preceding-sibling::*) = 0]'
      )
    end
  end
end
