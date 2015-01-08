require 'spec_helper'

describe Oga::XML::PullParser do
  describe 'doctypes' do
    before :all do
      @parser = described_class.new('<!DOCTYPE html>')
    end

    it 'ignores doctypes' do
      amount = 0

      @parser.parse do
        amount += 1
      end

      amount.should == 0
    end
  end
end
