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

      list.allow?('bar').should == true
      list.allow?('BAR').should == true
    end

    it 'returns false for a name in the list' do
      list = described_class.new(%w{foo})

      list.allow?('foo').should == false
      list.allow?('FOO').should == false
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
end
