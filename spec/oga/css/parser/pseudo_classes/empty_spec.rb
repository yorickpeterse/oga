require 'spec_helper'

describe Oga::CSS::Parser do
  describe ':empty pseudo class' do
    it 'parses the :empty pseudo class' do
      expect(parse_css(':empty')).to eq(parse_xpath('descendant::*[not(node())]'))
    end
  end
end
