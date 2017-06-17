require 'spec_helper'

describe Oga::XML::Parser do
  describe 'empty documents' do
    before :all do
      @document = parse('')
    end

    it 'returns a Document instance' do
      expect(@document.is_a?(Oga::XML::Document)).to eq(true)
    end
  end

  describe 'XML documents' do
    before :all do
      @document = parse('<foo></foo>')
    end

    it 'returns a Document instance' do
      expect(@document.is_a?(Oga::XML::Document)).to eq(true)
    end

    it 'sets the document type' do
      expect(@document.type).to eq(:xml)
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
      expect(@document.is_a?(Oga::XML::Document)).to eq(true)
    end

    it 'sets the document type' do
      expect(@document.type).to eq(:html)
    end

    it 'sets the doctype of the document' do
      expect(@document.doctype.is_a?(Oga::XML::Doctype)).to eq(true)
    end

    it 'sets the XML declaration of the document' do
      expect(@document.xml_declaration.is_a?(Oga::XML::XmlDeclaration)).to eq(true)
    end

    it 'sets the children of the document' do
      expect(@document.children.empty?).to eq(false)
    end
  end
end
