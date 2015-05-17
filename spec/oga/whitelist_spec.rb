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

      list.allow?('bar').should == false
      list.allow?('BAR').should == false
    end

    it 'returns true for a name in the list' do
      list = described_class.new(%w{foo})

      list.allow?('foo').should == true
      list.allow?('FOO').should == true
    end
  end

  describe '#+' do
    it 'returns a new Blacklist' do
      list1 = described_class.new(%w{foo})
      list2 = described_class.new(%w{bar})
      list3 = list1 + list2

      list3.should be_an_instance_of(described_class)
      list3.names.to_a.should == %w{foo FOO bar BAR}
    end
  end

  describe '#to_blacklist' do
    it 'returns a Blacklist containing the same values' do
      whitelist = described_class.new(%w{foo})
      blacklist = whitelist.to_blacklist

      blacklist.should be_an_instance_of(Oga::Blacklist)
      blacklist.names.should == whitelist.names
    end
  end
end
