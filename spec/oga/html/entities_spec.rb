# encoding: utf-8

require 'spec_helper'

describe Oga::HTML::Entities do
  describe 'decode' do
    it 'decodes &amp; into &' do
      described_class.decode('&amp;').should == '&'
    end

    it 'decodes &lambda; into λ' do
      described_class.decode('&lambda;').should == 'λ'
    end

    it 'decodes &frac12; into ½' do
      described_class.decode('&frac12;').should == '½'
    end
  end
end
