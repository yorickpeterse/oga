require 'spec_helper'

describe Oga::CSS::Parser do
  describe ':root pseudo class' do
    it 'parses the x:root pseudo class' do
      parse_css('x:root').should == parse_xpath('descendant::x[not(parent::*)]')
    end

    it 'parses the :root pseudo class' do
      parse_css(':root').should == parse_xpath('descendant::*[not(parent::*)]')
    end
  end
end
