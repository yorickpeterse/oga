require 'spec_helper'

describe Oga::EntityDecoder do
  describe 'try_decode' do
    it 'returns nil if the input is also nil' do
      described_class.try_decode(nil).should be_nil
    end

    it 'decodes XML entities' do
      described_class.try_decode('&lt;')
        .should == Oga::XML::Entities::DECODE_MAPPING['&lt;']
    end

    it 'decodes HTML entities' do
      described_class.try_decode('&copy;', true)
        .should == Oga::HTML::Entities::DECODE_MAPPING['&copy;']
    end
  end

  describe 'decode' do
    shared_examples "an HTML decoder" do
      it "decodes it" do
        described_class.decode(entity, true)
          .should == Oga::HTML::Entities::DECODE_MAPPING[entity]
      end
    end

    it 'decodes XML entities' do
      described_class.decode('&lt;')
        .should == Oga::XML::Entities::DECODE_MAPPING['&lt;']
    end

    context 'HTML entities' do
      context "Given a valid argument" do
        context "of &copy;" do
          let(:entity) { '&copy;' }
          it_behaves_like "an HTML decoder"
        end
        context "Given an argument of &sup1;" do
          let(:entity) { '&sup1;' }
          it_behaves_like "an HTML decoder"
        end
        context "Given an argument of &frac15;" do
          let(:entity) { '&frac15;' }
          it_behaves_like "an HTML decoder"
        end
      end
      context "Given an invalid argument" do
        context "of nil" do
          let(:entity) { nil }
          it "fails" do
            expect{ described_class.decode(entity, true) }.to raise_error(ArgumentError)
          end
        end
        context "of &&&&" do
          let(:entity) { "&&&&" }
          it "returns it unchanged" do
            described_class.decode(entity, true)
              .should == entity
          end
        end
        context "of 999" do
          let(:entity) { "999" }
          it "returns it unchanged" do
            described_class.decode(entity, true)
              .should == entity
          end
        end
        context "of and_copy;" do
          let(:entity) { "and_copy;" }
          it "returns it unchanged" do
            described_class.decode(entity, true)
              .should == entity
          end
        end
      end
    end
  end
end
