require 'spec_helper'

describe Oga::CSS::Parser do
  describe ':nth-of-type pseudo class' do
    it 'parses the x:nth-of-type(1) pseudo class' do
      expect(parse_css('x:nth-of-type(1)')).to eq(parse_xpath(
        'descendant::x[count(preceding-sibling::x) = 0]'
      ))
    end

    it 'parses the :nth-of-type(1) pseudo class' do
      expect(parse_css(':nth-of-type(1)')).to eq(parse_xpath(
        'descendant::*[count(preceding-sibling::*) = 0]'
      ))
    end

    it 'parses the :nth-of-type(2) pseudo class' do
      expect(parse_css(':nth-of-type(2)')).to eq(parse_xpath(
        'descendant::*[count(preceding-sibling::*) = 1]'
      ))
    end

    it 'parses the x:nth-of-type(even) pseudo class' do
      expect(parse_css('x:nth-of-type(even)')).to eq(parse_xpath(
        'descendant::x[((count(preceding-sibling::x) + 1) mod 2) = 0]'
      ))
    end

    it 'parses the x:nth-of-type(odd) pseudo class' do
      expect(parse_css('x:nth-of-type(odd)')).to eq(parse_xpath(
        'descendant::x[(count(preceding-sibling::x) + 1) >= 1 ' \
          'and (((count(preceding-sibling::x) + 1) - 1) mod 2) = 0]'
      ))
    end

    it 'parses the x:nth-of-type(n) pseudo class' do
      expect(parse_css('x:nth-of-type(n)')).to eq(parse_xpath(
        'descendant::x[((count(preceding-sibling::x) + 1) mod 1) = 0]'
      ))
    end

    it 'parses the x:nth-of-type(-n) pseudo class' do
      expect(parse_css('x:nth-of-type(-n)')).to eq(parse_xpath(
        'descendant::x[((count(preceding-sibling::x) + 1) mod 1) = 0]'
      ))
    end

    it 'parses the x:nth-of-type(-n+6) pseudo class' do
      expect(parse_css('x:nth-of-type(-n+6)')).to eq(parse_xpath(
        'descendant::x[((count(preceding-sibling::x) + 1) <= 6) ' \
          'and (((count(preceding-sibling::x) + 1) - 6) mod 1) = 0]'
      ))
    end

    it 'parses the x:nth-of-type(n+5) pseudo class' do
      expect(parse_css('x:nth-of-type(n+5)')).to eq(parse_xpath(
        'descendant::x[(count(preceding-sibling::x) + 1) >= 5 ' \
          'and (((count(preceding-sibling::x) + 1) - 5) mod 1) = 0]'
      ))
    end

    it 'parses the x:nth-of-type(2n) pseudo class' do
      expect(parse_css('x:nth-of-type(2n)')).to eq(parse_css('x:nth-of-type(even)'))
    end

    it 'parses the x:nth-of-type(2n+1) pseudo class' do
      expect(parse_css('x:nth-of-type(2n+1)')).to eq(parse_xpath(
        'descendant::x[(count(preceding-sibling::x) + 1) >= 1 ' \
          'and (((count(preceding-sibling::x) + 1) - 1) mod 2) = 0]'
      ))
    end

    it 'parses the x:nth-of-type(3n+1) pseudo class' do
      expect(parse_css('x:nth-of-type(3n+1)')).to eq(parse_xpath(
        'descendant::x[(count(preceding-sibling::x) + 1) >= 1 ' \
          'and (((count(preceding-sibling::x) + 1) - 1) mod 3) = 0]'
      ))
    end

    it 'parses the x:nth-of-type(2n-6) pseudo class' do
      expect(parse_css('x:nth-of-type(2n-6)')).to eq(parse_xpath(
        'descendant::x[(count(preceding-sibling::x) + 1) >= 2 ' \
          'and (((count(preceding-sibling::x) + 1) - 2) mod 2) = 0]'
      ))
    end

    it 'parses the x:nth-of-type(-2n+6) pseudo class' do
      expect(parse_css('x:nth-of-type(-2n+6)')).to eq(parse_xpath(
        'descendant::x[((count(preceding-sibling::x) + 1) <= 6) ' \
          'and (((count(preceding-sibling::x) + 1) - 6) mod 2) = 0]'
      ))
    end
  end
end
