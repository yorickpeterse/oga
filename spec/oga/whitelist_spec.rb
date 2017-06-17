require 'spec_helper'

describe Oga::Whitelist do
  describe '#each' do
    it 'yields each value in the list' do
      list = described_class.new(%w{foo bar})

      expect { |block| list.each(&block) }
        .to yield_successive_args('foo', 'bar', 'FOO', 'BAR')
    end
  end

  describe '#allow?' do
    it 'returns false for a name not in the list' do
      list = described_class.new(%w{foo})

      expect(list.allow?('bar')).to eq(false)
      expect(list.allow?('BAR')).to eq(false)
    end

    it 'returns true for a name in the list' do
      list = described_class.new(%w{foo})

      expect(list.allow?('foo')).to eq(true)
      expect(list.allow?('FOO')).to eq(true)
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

  describe '#to_blacklist' do
    it 'returns a Blacklist containing the same values' do
      whitelist = described_class.new(%w{foo})
      blacklist = whitelist.to_blacklist

      expect(blacklist).to be_an_instance_of(Oga::Blacklist)
      expect(blacklist.names).to eq(whitelist.names)
    end
  end
end
