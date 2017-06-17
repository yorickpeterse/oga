require 'spec_helper'

describe Oga::Blacklist do
  describe '#each' do
    it 'yields each value in the list' do
      list = described_class.new(%w{foo bar})

      expect { |block| list.each(&block) }
        .to yield_successive_args('foo', 'bar', 'FOO', 'BAR')
    end
  end

  describe '#allow?' do
    it 'returns true for a name not in the list' do
      list = described_class.new(%w{foo})

      expect(list.allow?('bar')).to eq(true)
      expect(list.allow?('BAR')).to eq(true)
    end

    it 'returns false for a name in the list' do
      list = described_class.new(%w{foo})

      expect(list.allow?('foo')).to eq(false)
      expect(list.allow?('FOO')).to eq(false)
    end
  end

  describe '#+' do
    it 'returns a new Blacklist' do
      list1 = described_class.new(%w{foo})
      list2 = described_class.new(%w{bar})
      list3 = list1 + list2

      expect(list3).to be_an_instance_of(described_class)
      expect(list3.names.to_a).to eq(%w{foo FOO bar BAR})
    end
  end
end
