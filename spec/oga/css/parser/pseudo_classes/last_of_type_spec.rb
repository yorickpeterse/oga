require 'spec_helper'

describe Oga::CSS::Parser do
  describe ':last-of-type pseudo class' do
    it 'parses the :last-of-type pseudo class' do
      expect(parse_css(':last-of-type')).to eq(parse_xpath(
        'descendant::*[count(following-sibling::*) = 0]'
      ))
    end

    it 'parses the a:last-of-type pseudo class' do
      expect(parse_css('a:last-of-type')).to eq(parse_xpath(
        'descendant::a[count(following-sibling::a) = 0]'
      ))
    end
  end
end
