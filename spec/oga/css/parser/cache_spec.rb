require 'spec_helper'

describe Oga::CSS::Parser do
  describe 'parse_with_cache' do
    after do
      described_class::CACHE.clear
    end

    it 'parses an expression' do
      described_class.parse_with_cache('foo')
        .should == s(:axis, 'descendant', s(:test, nil, 'foo'))
    end

    it 'caches an expression after parsing it' do
      described_class.any_instance
        .should_receive(:parse)
        .once
        .and_call_original

      described_class.parse_with_cache('foo')
        .should == s(:axis, 'descendant', s(:test, nil, 'foo'))

      described_class.parse_with_cache('foo')
        .should == s(:axis, 'descendant', s(:test, nil, 'foo'))
    end
  end
end
