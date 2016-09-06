require 'spec_helper'

describe Oga::XML::Parser do
  describe 'basic doctypes' do
    before :all do
      @document = parse('<!DOCTYPE html>')
    end

    it 'returns a Doctype instance' do
      @document.doctype.is_a?(Oga::XML::Doctype).should == true
    end

    it 'sets the name of the doctype' do
      @document.doctype.name.should == 'html'
    end
  end

  describe 'doctypes with a type' do
    before :all do
      @document = parse('<!DOCTYPE html PUBLIC>')
    end

    it 'returns a Doctype instance' do
      @document.doctype.is_a?(Oga::XML::Doctype).should == true
    end

    it 'sets the name of the doctype' do
      @document.doctype.name.should == 'html'
    end

    it 'sets the type of the doctype' do
      @document.doctype.type.should == 'PUBLIC'
    end
  end

  describe 'doctypes with a public ID' do
    before :all do
      @document = parse('<!DOCTYPE html PUBLIC "foo">')
    end

    it 'returns a Doctype instance' do
      @document.doctype.is_a?(Oga::XML::Doctype).should == true
    end

    it 'sets the name of the doctype' do
      @document.doctype.name.should == 'html'
    end

    it 'sets the type of the doctype' do
      @document.doctype.type.should == 'PUBLIC'
    end

    it 'sets the public ID of the doctype' do
      @document.doctype.public_id.should == 'foo'
    end
  end

  describe 'doctypes with a system ID' do
    before :all do
      @document = parse('<!DOCTYPE html PUBLIC "foo" "bar">')
    end

    it 'returns a Doctype instance' do
      @document.doctype.is_a?(Oga::XML::Doctype).should == true
    end

    it 'sets the name of the doctype' do
      @document.doctype.name.should == 'html'
    end

    it 'sets the type of the doctype' do
      @document.doctype.type.should == 'PUBLIC'
    end

    it 'sets the public ID of the doctype' do
      @document.doctype.public_id.should == 'foo'
    end

    it 'sets the system ID of the doctype' do
      @document.doctype.system_id.should == 'bar'
    end
  end

  describe 'doctypes with inline rules' do
    before :all do
      @document = parse('<!DOCTYPE html [<!ELEMENT foo>]>')
    end

    it 'returns a Doctype instance' do
      @document.doctype.is_a?(Oga::XML::Doctype).should == true
    end

    it 'sets the inline doctype rules' do
      @document.doctype.inline_rules.should == '<!ELEMENT foo>'
    end
  end

  describe 'doctypes with inline rules and newlines using a StringIO' do
    before :all do
      @document = parse(StringIO.new("<!DOCTYPE html [\nfoo]>"))
    end

    it 'sets the inline doctype rules' do
      @document.doctype.inline_rules.should == "\nfoo"
    end
  end

  describe 'doctypes with a type, public ID, system ID, and inline rules' do
    before :all do
      @document = parse('<!DOCTYPE svg PUBLIC "foo" "bar" [rule1]>')
    end

    it 'returns a Doctype instance' do
      @document.doctype.should be_an_instance_of(Oga::XML::Doctype)
    end

    it 'sets the name of the doctype' do
      @document.doctype.name.should == 'svg'
    end

    it 'sets the type of the doctype' do
      @document.doctype.type.should == 'PUBLIC'
    end

    it 'sets the public ID of the doctype' do
      @document.doctype.public_id.should == 'foo'
    end

    it 'sets the system ID of the doctype' do
      @document.doctype.system_id.should == 'bar'
    end

    it 'sets the inline rules of the doctype' do
      @document.doctype.inline_rules.should == 'rule1'
    end
  end
end
