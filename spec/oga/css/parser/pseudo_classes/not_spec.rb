require 'spec_helper'

describe Oga::CSS::Parser do
  describe ':not pseudo class' do
    it 'parses the :not(x) pseudo class' do
      parse_css(':not(x)').should == parse_xpath('descendant::*[not(self::x)]')
    end

    it 'parses the x:not(y) pseudo class' do
      parse_css('x:not(y)').should == parse_xpath('descendant::x[not(self::y)]')
    end

    it 'parses the x:not(#foo) pseudo class' do
      parse_css('x:not(#foo)').should ==
        parse_xpath('descendant::x[not(@id="foo")]')
    end
  end
end
