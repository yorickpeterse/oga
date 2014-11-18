require 'spec_helper'

describe Oga::XML::Parser do
  context 'basic doctypes' do
    before :all do
      @document = parse('<!DOCTYPE html>')
    end

    example 'return a Doctype instance' do
      @document.doctype.is_a?(Oga::XML::Doctype).should == true
    end

    example 'set the name of the doctype' do
      @document.doctype.name.should == 'html'
    end
  end

  context 'doctypes with a type' do
    before :all do
      @document = parse('<!DOCTYPE html PUBLIC>')
    end

    example 'return a Doctype instance' do
      @document.doctype.is_a?(Oga::XML::Doctype).should == true
    end

    example 'set the name of the doctype' do
      @document.doctype.name.should == 'html'
    end

    example 'set the type of the doctype' do
      @document.doctype.type.should == 'PUBLIC'
    end
  end

  context 'doctypes with a public ID' do
    before :all do
      @document = parse('<!DOCTYPE html PUBLIC "foo">')
    end

    example 'return a Doctype instance' do
      @document.doctype.is_a?(Oga::XML::Doctype).should == true
    end

    example 'set the name of the doctype' do
      @document.doctype.name.should == 'html'
    end

    example 'set the type of the doctype' do
      @document.doctype.type.should == 'PUBLIC'
    end

    example 'set the public ID of the doctype' do
      @document.doctype.public_id.should == 'foo'
    end
  end

  context 'doctypes with a system ID' do
    before :all do
      @document = parse('<!DOCTYPE html PUBLIC "foo" "bar">')
    end

    example 'return a Doctype instance' do
      @document.doctype.is_a?(Oga::XML::Doctype).should == true
    end

    example 'set the name of the doctype' do
      @document.doctype.name.should == 'html'
    end

    example 'set the type of the doctype' do
      @document.doctype.type.should == 'PUBLIC'
    end

    example 'set the public ID of the doctype' do
      @document.doctype.public_id.should == 'foo'
    end

    example 'set the system ID of the doctype' do
      @document.doctype.system_id.should == 'bar'
    end
  end

  context 'doctypes with inline rules' do
    before :all do
      @document = parse('<!DOCTYPE html [<!ELEMENT foo>]>')
    end

    example 'return a Doctype instance' do
      @document.doctype.is_a?(Oga::XML::Doctype).should == true
    end

    example 'set the inline doctype rules' do
      @document.doctype.inline_rules.should == '<!ELEMENT foo>'
    end
  end

  context 'doctypes with inline rules and newlines using a StringIO' do
    before :all do
      @document = parse(StringIO.new("<!DOCTYPE html [\nfoo]>"))
    end

    example 'set the inline doctype rules' do
      @document.doctype.inline_rules.should == "\nfoo"
    end
  end
end
