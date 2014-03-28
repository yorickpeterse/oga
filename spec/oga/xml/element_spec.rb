require 'spec_helper'

describe Oga::XML::Element do
  context 'setting attributes' do
    example 'set the name via the constructor' do
      described_class.new(:name => 'p').name.should == 'p'
    end

    example 'set the name via a setter' do
      instance = described_class.new
      instance.name = 'p'

      instance.name.should == 'p'
    end

    example 'set the default attributes' do
      described_class.new.attributes.should == {}
    end
  end

  context '#attribute' do
    before do
      @instance = described_class.new(:attributes => {'key' => 'value'})
    end

    example 'return an attribute' do
      @instance.attribute('key').should == 'value'
    end
  end

  context '#to_xml' do
    example 'generate the corresponding XML' do
      described_class.new(:name => 'p').to_xml.should == '<p></p>'
    end

    example 'include the namespace if present' do
      instance = described_class.new(:name => 'p', :namespace => 'foo')

      instance.to_xml.should == '<foo:p></p>'
    end

    example 'include the attributes if present' do
      instance = described_class.new(
        :name       => 'p',
        :attributes => {'key' => 'value'}
      )

      instance.to_xml.should == '<p key="value"></p>'
    end

    example 'include the child nodes if present' do
      instance = described_class.new(
        :name     => 'p',
        :children => [Oga::XML::Comment.new(:text => 'foo')]
      )

      instance.to_xml.should == '<p><!--foo--></p>'
    end
  end
end
