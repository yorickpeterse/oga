require 'spec_helper'

describe Oga::EntityDecoder do
  describe 'try_decode' do
    it 'returns nil if the input is also nil' do
      described_class.try_decode(nil).should be_nil
    end

    it 'decodes XML entities' do
      described_class.try_decode('&lt;')
        .should == Oga::XML::Entities::DECODE_MAPPING['&lt;']
    end

    it 'decodes HTML entities' do
      described_class.try_decode('&copy;', true)
        .should == Oga::HTML::Entities::DECODE_MAPPING['&copy;']
    end
  end

  describe 'decode' do
    it 'decodes XML entities' do
      described_class.decode('&lt;')
        .should == Oga::XML::Entities::DECODE_MAPPING['&lt;']
    end

    it 'decodes HTML entities' do
      described_class.decode('&copy;', true)
        .should == Oga::HTML::Entities::DECODE_MAPPING['&copy;']
    end
  end
end
