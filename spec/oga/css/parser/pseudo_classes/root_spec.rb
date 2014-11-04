require 'spec_helper'

describe Oga::CSS::Parser do
  context ':root pseudo class' do
    example 'parse the x:root pseudo class' do
      parse_css('x:root').should == parse_xpath('descendant::x[not(parent::*)]')
    end

    example 'parse the :root pseudo class' do
      parse_css(':root').should == parse_xpath('descendant::*[not(parent::*)]')
    end
  end
end
