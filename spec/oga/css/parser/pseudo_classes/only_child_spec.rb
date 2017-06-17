require 'spec_helper'

describe Oga::CSS::Parser do
  describe ':only-child pseudo class' do
    it 'parses the :only-child pseudo class' do
      expect(parse_css(':only-child')).to eq(parse_xpath(
        'descendant::*[count(preceding-sibling::*) = 0 ' \
          'and count(following-sibling::*) = 0]'
      ))
    end
  end
end
