require 'spec_helper'

describe Oga::XML::Doctype do
  context 'setting attributes' do
    example 'set the name via the constructor' do
      described_class.new(:name => 'html').name.should == 'html'
    end

    example 'set the name via a setter' do
      instance = described_class.new
      instance.name = 'html'

      instance.name.should == 'html'
    end
  end

  context '#to_xml' do
    example 'generate a bare minimum representation' do
      described_class.new(:name => 'html').to_xml.should == '<!DOCTYPE html>'
    end

    example 'include the type if present' do
      instance = described_class.new(:name => 'html', :type => 'PUBLIC')

      instance.to_xml.should == '<!DOCTYPE html PUBLIC>'
    end

    example 'include the public ID if present' do
      instance = described_class.new(
        :name      => 'html',
        :type      => 'PUBLIC',
        :public_id => 'foo'
      )

      instance.to_xml.should == '<!DOCTYPE html PUBLIC "foo">'
    end

    example 'include the system ID if present' do
      instance = described_class.new(
        :name      => 'html',
        :type      => 'PUBLIC',
        :public_id => 'foo',
        :system_id => 'bar'
      )

      instance.to_xml.should == '<!DOCTYPE html PUBLIC "foo" "bar">'
    end
  end
end
