require 'spec_helper'

describe Oga::CSS::Parser do
  describe ':nth-last-child pseudo class' do
    it 'parses the x:nth-last-child(1) pseudo class' do
      expect(parse_css('x:nth-last-child(1)')).to eq(parse_xpath(
        'descendant::x[count(following-sibling::*) = 0]'
      ))
    end

    it 'parses the :nth-last-child(1) pseudo class' do
      expect(parse_css(':nth-last-child(1)')).to eq(parse_xpath(
        'descendant::*[count(following-sibling::*) = 0]'
      ))
    end

    it 'parses the :nth-last-child(2) pseudo class' do
      expect(parse_css(':nth-last-child(2)')).to eq(parse_xpath(
        'descendant::*[count(following-sibling::*) = 1]'
      ))
    end

    it 'parses the x:nth-last-child(even) pseudo class' do
      expect(parse_css('x:nth-last-child(even)')).to eq(parse_xpath(
        'descendant::x[((count(following-sibling::*) + 1) mod 2) = 0]'
      ))
    end

    it 'parses the x:nth-last-child(odd) pseudo class' do
      expect(parse_css('x:nth-last-child(odd)')).to eq(parse_xpath(
        'descendant::x[(count(following-sibling::*) + 1) >= 1 ' \
          'and (((count(following-sibling::*) + 1) - 1) mod 2) = 0]'
      ))
    end

    it 'parses the x:nth-last-child(n) pseudo class' do
      expect(parse_css('x:nth-last-child(n)')).to eq(parse_xpath(
        'descendant::x[((count(following-sibling::*) + 1) mod 1) = 0]'
      ))
    end

    it 'parses the x:nth-last-child(-n) pseudo class' do
      expect(parse_css('x:nth-last-child(-n)')).to eq(parse_xpath(
        'descendant::x[((count(following-sibling::*) + 1) mod 1) = 0]'
      ))
    end

    it 'parses the x:nth-last-child(-n+6) pseudo class' do
      expect(parse_css('x:nth-last-child(-n+6)')).to eq(parse_xpath(
        'descendant::x[((count(following-sibling::*) + 1) <= 6) ' \
          'and (((count(following-sibling::*) + 1) - 6) mod 1) = 0]'
      ))
    end

    it 'parses the x:nth-last-child(2n) pseudo class' do
      expect(parse_css('x:nth-last-child(2n)')).to eq(parse_css(
        'x:nth-last-child(even)'
      ))
    end

    it 'parses the x:nth-last-child(2n+1) pseudo class' do
      expect(parse_css('x:nth-last-child(2n+1)')).to eq(parse_xpath(
        'descendant::x[(count(following-sibling::*) + 1) >= 1 ' \
          'and (((count(following-sibling::*) + 1) - 1) mod 2) = 0]'
      ))
    end

    it 'parses the x:nth-last-child(2n-6) pseudo class' do
      expect(parse_css('x:nth-last-child(2n-6)')).to eq(parse_xpath(
        'descendant::x[(count(following-sibling::*) + 1) >= 2 ' \
          'and (((count(following-sibling::*) + 1) - 2) mod 2) = 0]'
      ))
    end

    it 'parses the x:nth-last-child(-2n-6) pseudo class' do
      expect(parse_css('x:nth-last-child(-2n-6)')).to eq(parse_xpath(
        'descendant::x[((count(following-sibling::*) + 1) <= -2) ' \
          'and (((count(following-sibling::*) + 1) - -2) mod 2) = 0]'
      ))
    end

    it 'parses the x:nth-last-child(-2n+6) pseudo class' do
      expect(parse_css('x:nth-last-child(-2n+6)')).to eq(parse_xpath(
        'descendant::x[((count(following-sibling::*) + 1) <= 6) ' \
          'and (((count(following-sibling::*) + 1) - 6) mod 2) = 0]'
      ))
    end
  end
end
