require 'spec_helper'

describe Oga::CSS::Parser do
  describe ':nth-last-of-type pseudo class' do
    it 'parses the x:nth-last-of-type(1) pseudo class' do
      expect(parse_css('x:nth-last-of-type(1)')).to eq(parse_xpath(
        'descendant::x[count(following-sibling::x) = 0]'
      ))
    end

    it 'parses the :nth-last-of-type(1) pseudo class' do
      expect(parse_css(':nth-last-of-type(1)')).to eq(parse_xpath(
        'descendant::*[count(following-sibling::*) = 0]'
      ))
    end

    it 'parses the :nth-last-of-type(2) pseudo class' do
      expect(parse_css(':nth-last-of-type(2)')).to eq(parse_xpath(
        'descendant::*[count(following-sibling::*) = 1]'
      ))
    end

    it 'parses the x:nth-last-of-type(even) pseudo class' do
      expect(parse_css('x:nth-last-of-type(even)')).to eq(parse_xpath(
        'descendant::x[((count(following-sibling::x) + 1) mod 2) = 0]'
      ))
    end

    it 'parses the x:nth-last-of-type(odd) pseudo class' do
      expect(parse_css('x:nth-last-of-type(odd)')).to eq(parse_xpath(
        'descendant::x[(count(following-sibling::x) + 1) >= 1 ' \
          'and (((count(following-sibling::x) + 1) - 1) mod 2) = 0]'
      ))
    end

    it 'parses the x:nth-last-of-type(n) pseudo class' do
      expect(parse_css('x:nth-last-of-type(n)')).to eq(parse_xpath(
        'descendant::x[((count(following-sibling::x) + 1) mod 1) = 0]'
      ))
    end

    it 'parses the x:nth-last-of-type(-n) pseudo class' do
      expect(parse_css('x:nth-last-of-type(-n)')).to eq(parse_xpath(
        'descendant::x[((count(following-sibling::x) + 1) mod 1) = 0]'
      ))
    end

    it 'parses the x:nth-last-of-type(-n+6) pseudo class' do
      expect(parse_css('x:nth-last-of-type(-n+6)')).to eq(parse_xpath(
        'descendant::x[((count(following-sibling::x) + 1) <= 6) ' \
          'and (((count(following-sibling::x) + 1) - 6) mod 1) = 0]'
      ))
    end

    it 'parses the x:nth-last-of-type(n+5) pseudo class' do
      expect(parse_css('x:nth-last-of-type(n+5)')).to eq(parse_xpath(
        'descendant::x[(count(following-sibling::x) + 1) >= 5 ' \
          'and (((count(following-sibling::x) + 1) - 5) mod 1) = 0]'
      ))
    end

    it 'parses the x:nth-last-of-type(2n) pseudo class' do
      expect(parse_css('x:nth-last-of-type(2n)'))
        .to eq(parse_css('x:nth-last-of-type(even)'))
    end

    it 'parses the x:nth-last-of-type(2n+1) pseudo class' do
      expect(parse_css('x:nth-last-of-type(2n+1)')).to eq(parse_xpath(
        'descendant::x[(count(following-sibling::x) + 1) >= 1 ' \
          'and (((count(following-sibling::x) + 1) - 1) mod 2) = 0]'
      ))
    end

    it 'parses the x:nth-last-of-type(3n+1) pseudo class' do
      expect(parse_css('x:nth-last-of-type(3n+1)')).to eq(parse_xpath(
        'descendant::x[(count(following-sibling::x) + 1) >= 1 ' \
          'and (((count(following-sibling::x) + 1) - 1) mod 3) = 0]'
      ))
    end

    it 'parses the x:nth-last-of-type(2n-6) pseudo class' do
      expect(parse_css('x:nth-last-of-type(2n-6)')).to eq(parse_xpath(
        'descendant::x[(count(following-sibling::x) + 1) >= 2 ' \
          'and (((count(following-sibling::x) + 1) - 2) mod 2) = 0]'
      ))
    end

    it 'parses the x:nth-last-of-type(-2n+6) pseudo class' do
      expect(parse_css('x:nth-last-of-type(-2n+6)')).to eq(parse_xpath(
        'descendant::x[((count(following-sibling::x) + 1) <= 6) ' \
          'and (((count(following-sibling::x) + 1) - 6) mod 2) = 0]'
      ))
    end
  end
end
