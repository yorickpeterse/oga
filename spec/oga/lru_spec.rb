require 'spec_helper'

describe Oga::LRU do
  describe '#maximum=' do
    it 'sets the maximum amount of keys' do
      cache = described_class.new(10)

      cache.maximum = 20

      expect(cache.maximum).to eq(20)
    end

    it 'resizes the cache when needed' do
      cache = described_class.new(2)

      cache[:a] = 10
      cache[:b] = 20

      cache.maximum = 1

      expect(cache.size).to eq(1)
      expect(cache.keys).to eq([:b])
    end
  end

  describe '#maximum' do
    it 'returns the maximum amount of keys' do
      expect(described_class.new(5).maximum).to eq(5)
    end
  end

  describe '#[]' do
    it 'returns nil for a non existing key' do
      expect(described_class.new[:a]).to be_nil
    end

    it 'returns the value of an existing key' do
      cache = described_class.new

      cache[:a] = 10

      expect(cache[:a]).to eq(10)
    end
  end

  describe '#[]=' do
    it 'sets the value of a key' do
      cache = described_class.new

      cache[:a] = 10

      expect(cache[:a]).to eq(10)
    end

    it 'resizes the cache if the new amount of keys exceeds the limit' do
      cache = described_class.new(1)

      cache[:a] = 10
      cache[:b] = 20

      expect(cache.keys).to eq([:b])
    end

    it 'adds duplicate keys at the end of the list of keys' do
      cache = described_class.new

      cache[:a] = 10
      cache[:b] = 20
      cache[:a] = 30

      expect(cache.keys).to eq([:b, :a])
    end

    describe 'using multiple threads' do
      it 'supports concurrent writes' do
        cache   = described_class.new
        numbers = 1..10

        each_in_parallel(numbers) do |number|
          cache[number] = number
        end

        numbers.each do |number|
          expect(cache[number]).to eq(number)
        end
      end

      it 'supports concurrent resizes' do
        cache   = described_class.new(5)
        numbers = 1..10

        each_in_parallel(numbers) do |number|
          cache[number] = number
        end

        expect(cache.size).to eq(5)
      end
    end
  end

  describe '#get_or_set' do
    it 'sets a non existing key' do
      cache = described_class.new

      expect(cache.get_or_set(:a) { 10 }).to eq(10)
    end

    it 'returns the value of an existing key' do
      cache = described_class.new

      cache[:a] = 10

      expect(cache.get_or_set(:a) { 20 }).to eq(10)
    end

    describe 'using multiple threads' do
      it 'only sets a key once' do
        cache = described_class.new

        expect(cache).to receive(:[]=).once.and_call_original

        each_in_parallel([1, 1, 1]) do |number|
          cache.get_or_set(number) { number }
        end
      end
    end
  end

  describe '#keys' do
    it 'returns the keys of the cache' do
      cache = described_class.new

      cache[:a] = 10
      cache[:b] = 20

      expect(cache.keys).to eq([:a, :b])
    end

    it 'returns the keys without any duplicates' do
      cache = described_class.new

      cache[:a] = 10
      cache[:a] = 20

      expect(cache.keys).to eq([:a])
    end
  end

  describe '#key?' do
    it 'returns true for an existing key' do
      cache = described_class.new

      cache[:a] = 10

      expect(cache.key?(:a)).to eq(true)
    end

    it 'returns false for a non existing key' do
      cache = described_class.new

      expect(cache.key?(:a)).to eq(false)
    end
  end

  describe '#clear' do
    it 'removes all keys from the cache' do
      cache = described_class.new

      cache[:a] = 10

      cache.clear

      expect(cache.size).to eq(0)
    end
  end

  describe '#size' do
    it 'returns 0 for an empty cache' do
      expect(described_class.new.size).to eq(0)
    end

    it 'returns the number of keys for a non empty cache' do
      cache = described_class.new

      cache[:a] = 10

      expect(cache.size).to eq(1)
    end
  end
end
