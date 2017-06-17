require 'spec_helper'

describe Oga::CSS::Parser do
  describe ':last-child pseudo class' do
    it 'parses the :last-child pseudo class' do
      expect(parse_css(':last-child')).to eq(parse_xpath(
        'descendant::*[count(following-sibling::*) = 0]'
      ))
    end
  end
end
