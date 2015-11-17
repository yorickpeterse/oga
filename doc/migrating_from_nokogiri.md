# Migrating From Nokogiri

If you're parsing XML/HTML documents using Ruby, chances are you're using
[Nokogiri][nokogiri] for this. This guide aims to make it easier to switch from
Nokogiri to Oga.

## Parsing Documents

In Nokogiri there are two defacto ways of parsing documents:

* `Nokogiri.XML()` for XML documents
* `Nokogiri.HTML()` for HTML documents

For example, to parse an XML document you'd use the following:

    Nokogiri::XML('<root>foo</root>')

Oga instead uses the following two methods:

* `Oga.parse_xml`
* `Oga.parse_html`

Their usage is similar:

    Oga.parse_xml('<root>foo</root>')

Nokogiri returns two distinctive document classes based on what method was used
to parse a document:

* `Nokogiri::XML::Document` for XML documents
* `Nokogiri::HTML::Document` for HTML documents

Oga on the other hand always returns `Oga::XML::Document` instance, Oga
currently makes no distinction between XML and HTML documents other than on
lexer level. This might change in the future if deemed required.

## Querying Documents

Nokogiri allows one to query documents/elements using both XPath expressions and
CSS selectors. In Nokogiri one queries a document as following:

    document = Nokogiri::XML('<root><foo>bar</foo></root>')

    document.xpath('root/foo')
    document.css('root foo')

Querying documents works similar to Nokogiri:

    document = Oga.parse_xml('<root><foo>bar</foo></root>')

    document.xpath('root/foo')

or using CSS:

    document = Oga.parse_xml('<root><foo>bar</foo></root>')

    document.css('root foo')

Nokogiri also allows you to query a document and return the first match, opposed
to an entire node set, using the method `at`. In Nokogiri this method can be
used for both XPath expression and CSS selectors. Oga has no such method,
instead it provides the following more dedicated methods:

* `at_xpath`: returns the first node of an XPath expression
* `at_css`: returns the first node of a CSS expression

For example:

    document = Oga.parse_xml('<root><foo>bar</foo></root>')

    document.at_xpath('root/foo')

By using a dedicated method Oga doesn't have to try and guess what type of
expression you're using (XPath or CSS), meaning it can never make any mistakes.

## Retrieving Attribute Values

Nokogiri provides two methods for retrieving attributes and attribute values:

* `Nokogiri::XML::Node#attribute`
* `Nokogiri::XML::Node#attr`

The first method always returns an instance of `Nokogiri::XML::Attribute`, the
second method returns the attribute value as a `String`. This behaviour,
especially due to the names used, is extremely confusing.

Oga on the other hand provides the following two methods:

* `Oga::XML::Element#attribute` (aliased as `attr`)
* `Oga::XML::Element#get`

The first method always returns a `Oga::XML::Attribute` instance, the second
returns the attribute value as a `String`. I deliberately chose `get` for
getting a value to remove the confusion of `attribute` vs `attr`. This also
allows for `attr` to simply be an alias of `attribute`.

As an example, this is how you'd get the value of a `class` attribute in
Nokogiri:

    document = Nokogiri::XML('<root class="foo"></root>')

    document.xpath('root').first.attr('class') # => "foo"

This is how you'd get the same value in Oga:

    document = Oga.parse_xml('<root class="foo"></root>')

    document.xpath('root').first.get('class') # => "foo"

## Modifying Documents

Modifying documents in Nokogiri is not as convenient as it perhaps could be. For
example, adding an element to a document is done as following:

    document = Nokogiri::XML('<root></root>')
    root     = document.xpath('root').first

    name = Nokogiri::XML::Element.new('name', document)

    name.inner_html = 'Alice'

    root.add_child(name)

The annoying part here is that we have to pass a document into an Element's
constructor. As such, you can not create elements without first creating a
document. Another thing is that Nokogiri has no method called `inner_text=`,
instead you have to use the method `inner_html=`.

In Oga you'd use the following:

    document = Oga.parse_xml('<root></root>')
    root     = document.xpath('root').first

    name = Oga::XML::Element.new(:name => 'name')

    name.inner_text = 'Alice'

    root.children << name

Adding attributes works similar for both Nokogiri and Oga. For Nokogiri you'd
use the following:

    element.set_attribute('class', 'foo')

Alternatively you can do the following:

    element['class'] = 'foo'

In Oga you'd instead use the method `set`:

    element.set('class', 'foo')

This method automatically creates an attribute if it doesn't exist, including
the namespace if specified:

    element.set('foo:class', 'foo')

## Serializing Documents

Serializing the document back to XML works the same in both libraries, simply
call `to_xml` on a document or element and you'll get a String back containing
the XML. There is one key difference here though: Nokogiri does not return the
exact same output as it was given as input, for example it adds XML declaration
tags:

    Nokogiri::XML('<root></root>').to_xml # => "<?xml version=\"1.0\"?>\n<root/>\n"

Oga on the other hand does not do this:

    Oga.parse_xml('<root></root>').to_xml # => "<root></root>"

Oga also doesn't insert random newlines or other possibly unexpected (or
unwanted) data.

[nokogiri]: http://nokogiri.org/
