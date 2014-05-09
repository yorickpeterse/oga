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

    example 'include the inline rules if present' do
      instance = described_class.new(
        :name         => 'html',
        :inline_rules => '<!ELEMENT foo>'
      )

      instance.to_xml.should == '<!DOCTYPE html [<!ELEMENT foo>]>'
    end
  end

  context '#inspect' do
    before do
      @instance = described_class.new(
        :name         => 'html',
        :type         => 'PUBLIC',
        :inline_rules => '<!ELEMENT foo>'
      )
    end

    example 'pretty-print the node' do
      @instance.inspect.should == <<-EOF.strip
Doctype(
  name: "html"
  type: "PUBLIC"
  public_id: nil
  system_id: nil
  inline_rules: "<!ELEMENT foo>"
)
      EOF
    end
  end

  context '#type' do
    example 'return the type of the node' do
      described_class.new.node_type.should == :doctype
    end
  end
end
