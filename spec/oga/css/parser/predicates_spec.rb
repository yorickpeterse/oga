require 'spec_helper'

describe Oga::CSS::Parser do
  context 'predicates' do
    example 'parse a predicate' do
      parse_css('foo[bar]').should == parse_xpath('descendant::foo[@bar]')
    end

    example 'parse a node test followed by a node test with a predicate' do
      parse_css('foo bar[baz]').should == parse_xpath(
        'descendant::foo/descendant::bar[@baz]'
      )
    end

    example 'parse a predicate testing an attribute value' do
      parse_css('foo[bar="baz"]').should == parse_xpath(
        'descendant::foo[@bar="baz"]'
      )
    end
  end
end
