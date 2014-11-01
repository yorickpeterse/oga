require 'spec_helper'

describe Oga::CSS::Parser do
  context ':root pseudo class' do
    example 'parse the x:root pseudo class' do
      parse_css('x:root').should == parse_xpath(
        'descendant-or-self::x[not(parent::*)]'
      )
    end

    example 'parse the :root pseudo class' do
      parse_css(':root').should == parse_xpath(
        'descendant-or-self::*[not(parent::*)]'
      )
    end
  end
end
