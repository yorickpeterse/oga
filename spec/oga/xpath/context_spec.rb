require 'spec_helper'

describe Oga::XPath::Context do
  describe '#evaluate' do
    it 'returns the result of eval()' do
      context = described_class.new

      context.evaluate('10').should == 10
    end

    describe 'assigning a variable in a lambda' do
      it 'assigns the variable locally to the lambda' do
        context = described_class.new

        block = context.evaluate('lambda { number = 10 }')

        block.call

        expect { context.evaluate('number') }.to raise_error(NameError)
      end
    end
  end
end
