require 'spec_helper'

describe Oga::XML::Parser do
  context 'empty documents' do
    before :all do
      @document = parse('')
    end

    example 'return a Document instance' do
      @document.is_a?(Oga::XML::Document).should == true
    end
  end

  context 'HTML documents' do
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

    example 'return a Document instance' do
      @document.is_a?(Oga::XML::Document).should == true
    end

    example 'set the doctype of the document' do
      @document.doctype.is_a?(Oga::XML::Doctype).should == true
    end

    example 'set the XML declaration of the document' do
      @document.xml_declaration.is_a?(Oga::XML::XmlDeclaration).should == true
    end

    example 'set the children of the document' do
      @document.children.empty?.should == false
    end
  end
end
