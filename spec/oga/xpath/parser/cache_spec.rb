require 'spec_helper'

describe Oga::XPath::Parser do
  describe 'parse_with_cache' do
    after do
      described_class::CACHE.clear
    end

    it 'parses an expression' do
      expect(described_class.parse_with_cache('foo'))
        .to eq(s(:axis, 'child', s(:test, nil, 'foo')))
    end

    it 'caches an expression after parsing it' do
      expect_any_instance_of(described_class)
        .to receive(:parse)
        .once
        .and_call_original

      expect(described_class.parse_with_cache('foo'))
        .to eq(s(:axis, 'child', s(:test, nil, 'foo')))

      expect(described_class.parse_with_cache('foo'))
        .to eq(s(:axis, 'child', s(:test, nil, 'foo')))
    end
  end
end
