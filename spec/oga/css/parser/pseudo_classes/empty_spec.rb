require 'spec_helper'

describe Oga::CSS::Parser do
  context ':empty pseudo class' do
    example 'parse the :empty pseudo class' do
      parse_css(':empty').should == parse_xpath(
        'descendant-or-self::*[not(node())]'
      )
    end
  end
end
