require 'spec_helper'

describe Oga::XML::Parser do
  describe 'empty documents' do
    before :all do
      @document = parse('')
    end

    it 'returns a Document instance' do
      @document.is_a?(Oga::XML::Document).should == true
    end
  end

  describe 'XML documents' do
    before :all do
      @document = parse('<foo></foo>')
    end

    it 'returns a Document instance' do
      @document.is_a?(Oga::XML::Document).should == true
    end

    it 'sets the document type' do
      @document.type.should == :xml
    end
  end

  describe 'HTML documents' do
    before :all do
      html = <<-EOF.strip
<?xml version="1.5" ?>
<!DOCTYPE html>
<html>
<head>
<title>Title</title>
</head>
<body></body>
</html>
      EOF

      @document = parse(html, :html => true)
    end

    it 'returns a Document instance' do
      @document.is_a?(Oga::XML::Document).should == true
    end

    it 'sets the document type' do
      @document.type.should == :html
    end

    it 'sets the doctype of the document' do
      @document.doctype.is_a?(Oga::XML::Doctype).should == true
    end

    it 'sets the XML declaration of the document' do
      @document.xml_declaration.is_a?(Oga::XML::XmlDeclaration).should == true
    end

    it 'sets the children of the document' do
      @document.children.empty?.should == false
    end
  end
end
