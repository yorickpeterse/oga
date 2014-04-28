require 'spec_helper'

describe Oga::XML::PullParser do
  context 'doctypes' do
    before :all do
      @parser = described_class.new('<!DOCTYPE html>')
    end

    example 'ignore doctypes' do
      amount = 0

      @parser.parse do
        amount += 1
      end

      amount.should == 0
    end
  end
end
