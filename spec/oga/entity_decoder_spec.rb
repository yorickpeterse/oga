require 'spec_helper'

describe Oga::EntityDecoder do
  describe 'try_decode' do
    it 'returns nil if the input is also nil' do
      expect(described_class.try_decode(nil)).to be_nil
    end

    it 'decodes XML entities' do
      expect(described_class.try_decode('&lt;'))
        .to eq(Oga::XML::Entities::DECODE_MAPPING['&lt;'])
    end

    it 'decodes HTML entities' do
      expect(described_class.try_decode('&copy;', true))
        .to eq(Oga::HTML::Entities::DECODE_MAPPING['&copy;'])
    end
  end

  describe 'decode' do
    it 'decodes XML entities' do
      expect(described_class.decode('&lt;'))
        .to eq(Oga::XML::Entities::DECODE_MAPPING['&lt;'])
    end

    it 'decodes HTML entities' do
      expect(described_class.decode('&copy;', true))
        .to eq(Oga::HTML::Entities::DECODE_MAPPING['&copy;'])
    end
  end
end
