# Manually Creating Documents

Besides being able to parse documents, Oga also allows you to create documents
manually. This can be useful if you want to dynamically generate XML/HTML.

Documents can be greated in two ways:

1. Full blown documents (using {Oga::XML::Document})
2. XML fragments (using just {Oga::XML::Element} and the likes)

For example, lets create a document with a specific encoding and a single
element:

    xml_decl = Oga::XML::XmlDeclaration.new(:encoding => 'UTF-16')
    document = Oga::XML::Document.new(:xml_declaration => xml_decl)
    element  = Oga::XML::Element.new(:name => 'example')

    document.children << element

If you now serialize this back to XML (by calling `document.to_xml`) you'd get
the following XML:

    <?xml version="1.0" encoding="UTF-16" ?>
    <example />

You can also serialize elements on their own:

    element.to_xml

This would output:

    <example />

## Adding/Removing Attributes

The easiest way to add (or remove) attributes is by using {Oga::XML::Element#set}
and {Oga::XML::Element#unset}. For example, to add an attribute:

    element = Oga::XML::Element.new(:name => 'example')

    element.set('class', 'foo')

    element.to_xml # => "<example class=\"foo\" />"

And to remove an attribute:

    element.unset('class')

## Modifying Text

Modifying text of elements can be done in two ways:

1. Adding {Oga::XML::Text} instances to the list of child nodes of an
   {Oga::XML::Element} instance
2. Using {Oga::XML::Element#inner\_text=}

The second option is the easiest and recommended way of doing this. Usage is
quite simple:

    element = Oga::XML::Element.new(:name => 'p')

    element.inner_text = 'Hello'

    element.to_xml => "<p>Hello</p>"

Special characters such as `&` and `<` are escaped automatically when calling
{Oga::XML::Element#to_xml}.
