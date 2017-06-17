require 'spec_helper'

describe Oga::XML::Parser do
  describe 'basic doctypes' do
    before :all do
      @document = parse('<!DOCTYPE html>')
    end

    it 'returns a Doctype instance' do
      expect(@document.doctype.is_a?(Oga::XML::Doctype)).to eq(true)
    end

    it 'sets the name of the doctype' do
      expect(@document.doctype.name).to eq('html')
    end
  end

  describe 'doctypes with a type' do
    before :all do
      @document = parse('<!DOCTYPE html PUBLIC>')
    end

    it 'returns a Doctype instance' do
      expect(@document.doctype.is_a?(Oga::XML::Doctype)).to eq(true)
    end

    it 'sets the name of the doctype' do
      expect(@document.doctype.name).to eq('html')
    end

    it 'sets the type of the doctype' do
      expect(@document.doctype.type).to eq('PUBLIC')
    end
  end

  describe 'doctypes with a public ID' do
    before :all do
      @document = parse('<!DOCTYPE html PUBLIC "foo">')
    end

    it 'returns a Doctype instance' do
      expect(@document.doctype.is_a?(Oga::XML::Doctype)).to eq(true)
    end

    it 'sets the name of the doctype' do
      expect(@document.doctype.name).to eq('html')
    end

    it 'sets the type of the doctype' do
      expect(@document.doctype.type).to eq('PUBLIC')
    end

    it 'sets the public ID of the doctype' do
      expect(@document.doctype.public_id).to eq('foo')
    end
  end

  describe 'doctypes with a system ID' do
    before :all do
      @document = parse('<!DOCTYPE html PUBLIC "foo" "bar">')
    end

    it 'returns a Doctype instance' do
      expect(@document.doctype.is_a?(Oga::XML::Doctype)).to eq(true)
    end

    it 'sets the name of the doctype' do
      expect(@document.doctype.name).to eq('html')
    end

    it 'sets the type of the doctype' do
      expect(@document.doctype.type).to eq('PUBLIC')
    end

    it 'sets the public ID of the doctype' do
      expect(@document.doctype.public_id).to eq('foo')
    end

    it 'sets the system ID of the doctype' do
      expect(@document.doctype.system_id).to eq('bar')
    end
  end

  describe 'doctypes with inline rules' do
    before :all do
      @document = parse('<!DOCTYPE html [<!ELEMENT foo>]>')
    end

    it 'returns a Doctype instance' do
      expect(@document.doctype.is_a?(Oga::XML::Doctype)).to eq(true)
    end

    it 'sets the inline doctype rules' do
      expect(@document.doctype.inline_rules).to eq('<!ELEMENT foo>')
    end
  end

  describe 'doctypes with inline rules and newlines using a StringIO' do
    before :all do
      @document = parse(StringIO.new("<!DOCTYPE html [\nfoo]>"))
    end

    it 'sets the inline doctype rules' do
      expect(@document.doctype.inline_rules).to eq("\nfoo")
    end
  end

  describe 'doctypes with a type, public ID, system ID, and inline rules' do
    before :all do
      @document = parse('<!DOCTYPE svg PUBLIC "foo" "bar" [rule1]>')
    end

    it 'returns a Doctype instance' do
      expect(@document.doctype).to be_an_instance_of(Oga::XML::Doctype)
    end

    it 'sets the name of the doctype' do
      expect(@document.doctype.name).to eq('svg')
    end

    it 'sets the type of the doctype' do
      expect(@document.doctype.type).to eq('PUBLIC')
    end

    it 'sets the public ID of the doctype' do
      expect(@document.doctype.public_id).to eq('foo')
    end

    it 'sets the system ID of the doctype' do
      expect(@document.doctype.system_id).to eq('bar')
    end

    it 'sets the inline rules of the doctype' do
      expect(@document.doctype.inline_rules).to eq('rule1')
    end
  end

  describe 'doctypes inside an element' do
    before :all do
      @document = parse('<foo><!DOCTYPE html><bar /></foo>')
    end

    it 'does not set the doctype of the document' do
      # This is because the doctype does not reside at the root. Supporting
      # doctypes at arbitrary locations would come at a hefty performance
      # impact, and requires doctypes to reach back into their owning documents
      # (which leads to ugly code).
      expect(@document.doctype).to be_nil
    end

    it 'sets the next node of the doctype' do
      doctype = @document.children[0].children[0]
      bar = @document.children[0].children[1]

      expect(doctype.next).to eq(bar)
    end
  end
end
