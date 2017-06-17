require 'spec_helper'

describe Oga::CSS::Parser do
  describe 'operators' do
    it 'parses the = operator' do
      expect(parse_css('x[a="b"]')).to eq(parse_xpath('descendant::x[@a="b"]'))
    end

    it 'parses the ~= operator' do
      expect(parse_css('x[a~="b"]')).to eq(parse_xpath(
        'descendant::x[contains(concat(" ", @a, " "), ' \
          'concat(" ", "b", " "))]'
      ))
    end

    it 'parses the ^= operator' do
      expect(parse_css('x[a^="b"]')).to eq(parse_xpath(
        'descendant::x[starts-with(@a, "b")]'
      ))
    end

    it 'parses the $= operator' do
      expect(parse_css('x[a$="b"]')).to eq(parse_xpath(
        'descendant::x[substring(@a, string-length(@a) - ' \
          'string-length("b") + 1, string-length("b")) = "b"]'
      ))
    end

    it 'parses the *= operator' do
      expect(parse_css('x[a*="b"]')).to eq(parse_xpath(
        'descendant::x[contains(@a, "b")]'
      ))
    end

    it 'parses the |= operator' do
      expect(parse_css('x[a|="b"]')).to eq(parse_xpath(
        'descendant::x[@a = "b" or starts-with(@a, concat("b", "-"))]'
      ))
    end
  end
end
