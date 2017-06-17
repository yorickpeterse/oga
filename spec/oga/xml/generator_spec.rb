require 'spec_helper'

describe Oga::XML::Generator do
  describe '#to_xml' do
    describe 'using an unsupported root type' do
      it 'raises TypeError' do
        expect { described_class.new(:foo).to_xml }.to raise_error(TypeError)
      end
    end

    describe 'using an Element as the root node' do
      it 'returns a String' do
        element = Oga::XML::Element.new(name: 'foo')
        element.set('attr', 'value')

        output = described_class.new(element).to_xml

        expect(output).to eq('<foo attr="value" />')
      end
    end

    describe 'using a Document as the root node' do
      it 'returns a String' do
        element = Oga::XML::Element.new(name: 'foo')
        doc = Oga::XML::Document.new(children: [element])
        output = described_class.new(doc).to_xml

        expect(output).to eq('<foo />')
      end
    end

    describe 'using an HTML Document as the root node' do
      it 'returns a String' do
        element = Oga::XML::Element.new(name: 'foo')
        doc = Oga::XML::Document.new(children: [element], type: :html)
        output = described_class.new(doc).to_xml

        expect(output).to eq('<foo></foo>')
      end
    end

    describe 'using an HTML Document as the root node with nested elements' do
      it 'returns a String' do
        el2 = Oga::XML::Element.new(name: 'bar')
        el1 = Oga::XML::Element.new(name: 'foo', children: [el2])
        doc = Oga::XML::Document.new(children: [el1], type: :html)
        output = described_class.new(doc).to_xml

        expect(output).to eq('<foo><bar></bar></foo>')
      end
    end

    describe 'using Element nodes with siblings' do
      it 'returns a String' do
        root = Oga::XML::Element.new(
          name: 'root',
          children: [
            Oga::XML::Element.new(name: 'a'),
            Oga::XML::Element.new(
              name: 'b',
              children: [Oga::XML::Element.new(name: 'c')]
            )
          ]
        )

        output = described_class.new(root).to_xml

        expect(output).to eq('<root><a /><b><c /></b></root>')
      end
    end

    describe 'using a Text node in a Document as the root node' do
      it 'returns a String' do
        text     = Oga::XML::Text.new(text: "\n")
        element  = Oga::XML::Element.new(name: 'foo')
        document = Oga::XML::Document.new(children: [text, element])

        expect(described_class.new(text).to_xml).to eq("\n")
      end
    end

    describe 'using an Element in a Document as the root node' do
      it 'returns a String' do
        text     = Oga::XML::Text.new(text: "\n")
        element  = Oga::XML::Element.new(name: 'foo')
        document = Oga::XML::Document.new(children: [text, element])

        expect(described_class.new(element).to_xml).to eq('<foo />')
      end
    end

    describe 'using an Element with a sibling as the root node' do
      it 'returns a String' do
        element1 = Oga::XML::Element.new(name: 'a')
        element2 = Oga::XML::Element.new(name: 'b')
        document = Oga::XML::Document.new(children: [element1, element2])

        expect(described_class.new(element1).to_xml).to eq('<a />')
        expect(described_class.new(element2).to_xml).to eq('<b />')
      end
    end

    describe 'using a parsed HTML document' do
      it 'returns a String with the same formatting as the input document' do
        input = <<-EOF
<!DOCTYPE html>
<html>
  <head>
    <title>Hello</title>
    <meta charset="utf-8">
  </head>
  <body>
    <p>Hello</p>
    <ul>
      <li>Hello</li>
      <li></li>
      Hello
    </ul>
  <div></div></body>
</html>
        EOF

        doc = Oga.parse_html(input)
        output = described_class.new(doc)

        expect(output.to_xml).to eq(input)
      end
    end

    describe 'using an XML document containing HTML void elements' do
      describe 'using empty void elements' do
        it 'returns a String' do
          img = Oga::XML::Element.new(name: 'img')
          doc = Oga::XML::Document.new(children: [img], type: :xml)

          expect(doc.to_xml).to eq('<img />')
        end
      end

      describe 'using non-empty void elements' do
        it 'returns a String' do
          text = Oga::XML::Text.new(text: 'kittens')
          img = Oga::XML::Element.new(name: 'img', children: [text])
          doc = Oga::XML::Document.new(children: [img], type: :xml)

          expect(doc.to_xml).to eq('<img>kittens</img>')
        end
      end
    end

    describe 'using an HTML document containing HTML void elements' do
      describe 'using empty void elements' do
        it 'returns a String' do
          img = Oga::XML::Element.new(name: 'img')
          doc = Oga::XML::Document.new(children: [img], type: :html)

          expect(doc.to_xml).to eq('<img>')
        end
      end

      describe 'using non-empty void elements' do
        it 'returns a String' do
          text = Oga::XML::Text.new(text: 'kittens')
          img = Oga::XML::Element.new(name: 'img', children: [text])
          doc = Oga::XML::Document.new(children: [img], type: :html)

          expect(doc.to_xml).to eq('<img>kittens</img>')
        end
      end
    end
  end
end
