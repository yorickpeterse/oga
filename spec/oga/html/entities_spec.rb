# encoding: utf-8

require 'spec_helper'

describe Oga::HTML::Entities do
  describe 'decode' do
    it 'decodes &amp; into &' do
      expect(described_class.decode('&amp;')).to eq('&')
    end

    it 'decodes &lambda; into λ' do
      expect(described_class.decode('&lambda;')).to eq('λ')
    end

    it 'decodes &frac12; into ½' do
      expect(described_class.decode('&frac12;')).to eq('½')
    end
  end
end
