require 'spec_helper'

describe Oga::XML::Doctype do
  describe 'setting attributes' do
    it 'sets the name via the constructor' do
      expect(described_class.new(:name => 'html').name).to eq('html')
    end

    it 'sets the name via a setter' do
      instance = described_class.new
      instance.name = 'html'

      expect(instance.name).to eq('html')
    end
  end

  describe '#to_xml' do
    it 'generates a bare minimum representation' do
      expect(described_class.new(:name => 'html').to_xml).to eq('<!DOCTYPE html>')
    end

    it 'includes the type if present' do
      instance = described_class.new(:name => 'html', :type => 'PUBLIC')

      expect(instance.to_xml).to eq('<!DOCTYPE html PUBLIC>')
    end

    it 'includes the public ID if present' do
      instance = described_class.new(
        :name      => 'html',
        :type      => 'PUBLIC',
        :public_id => 'foo'
      )

      expect(instance.to_xml).to eq('<!DOCTYPE html PUBLIC "foo">')
    end

    it 'includes the system ID if present' do
      instance = described_class.new(
        :name      => 'html',
        :type      => 'PUBLIC',
        :public_id => 'foo',
        :system_id => 'bar'
      )

      expect(instance.to_xml).to eq('<!DOCTYPE html PUBLIC "foo" "bar">')
    end

    it 'includes the inline rules if present' do
      instance = described_class.new(
        :name         => 'html',
        :inline_rules => '<!ELEMENT foo>'
      )

      expect(instance.to_xml).to eq('<!DOCTYPE html [<!ELEMENT foo>]>')
    end
  end

  describe '#inspect' do
    before do
      @instance = described_class.new(
        :name         => 'html',
        :type         => 'PUBLIC',
        :inline_rules => '<!ELEMENT foo>'
      )
    end

    it 'pretty-prints the node' do
      expect(@instance.inspect).to eq <<-EOF.strip
Doctype(name: "html" type: "PUBLIC" inline_rules: "<!ELEMENT foo>")
      EOF
    end
  end
end
