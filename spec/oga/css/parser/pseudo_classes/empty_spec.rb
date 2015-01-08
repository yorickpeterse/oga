require 'spec_helper'

describe Oga::CSS::Parser do
  describe ':empty pseudo class' do
    it 'parses the :empty pseudo class' do
      parse_css(':empty').should == parse_xpath('descendant::*[not(node())]')
    end
  end
end
