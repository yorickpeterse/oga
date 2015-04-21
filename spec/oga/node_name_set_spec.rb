require 'spec_helper'

describe Oga::NodeNameSet do
  describe '#initialize' do
    it 'adds uppercase equivalents of the input strings' do
      set = described_class.new(%w{foo bar})

      set.to_a.should == %w{foo bar FOO BAR}
    end
  end
end
