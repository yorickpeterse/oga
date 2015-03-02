# Changelog

This document contains details of the various releases and their release dates.
Dates are in the format `yyyy-mm-dd`.

## 0.2.1 - Unreleased

### Proper HTML serializing support for script tags

When serializing an HTML document back to HTML (as a String) the contents of
`<script>` tags are serialized correctly. Previously XML unsafe characters
(e.g. `<`) would be converted to XML entities, which results in invalid
Javascript syntax. This has been changed so that `<script>` tags in HTML
documents _don't_ have their contents converted, ensuring proper Javascript
syntax upon output.

See commit 874d7124af540f0bc78e6c586868bbffb4310c5d and issue
<https://github.com/YorickPeterse/oga/issues/79> for more information.

### Proper lexing support for script tags

When lexing HTML documents the XML lexer is now capable of lexing the contents
of `<script>` tags properly. Previously input such as `<script>x >y</script>`
would result in incorrect tokens being emitted. See commit
ba2177e2cfda958ea12c5b04dbf60907aaa8816d and issue
<https://github.com/YorickPeterse/oga/issues/70> for more information.

### Element Inner Text

When setting the inner text of an element using `Oga::XML::Element#inner_text=`
_all_ child nodes of the element are now removed first, instead of only text
nodes being removed.

See <https://github.com/YorickPeterse/oga/issues/64> for more information.

### Support for extra XML entities

Support for encoding/decoding extra XML entities was added by Dmitry
Krasnoukhov. This includes entities such as `&#60`, `&#34`, etc. See commit
26baf89440d97bd9dd5e50ec3d6d9b7ab3bdf737 for more information.

### Support for inline doctypes with newlines in IO input

The XML lexer (and thus the parser) can now handle inline doctypes containing
newlines when using an IO object as the input. For example:

    <!DOCTYPE html[foo
    bar]>

Previously this would result in incorrect tokens being emitted by the lexer. See
commit cbb2815146a79805b8da483d2ef48d17e2959e72 for more information.

## 0.2.0 - 2014-11-17

### CSS Selector Support

Probably the biggest feature of this release: support for querying documents
using CSS selectors. Oga supports a subset of the CSS3 selector specification,
in particular the following selectors are supported:

* Element, class and ID selectors
* Attribute selectors (e.g. `foo[x ~= "y"]`)

The following pseudo classes are supported:

* `:root`
* `:nth-child(n)`
* `:nth-last-child(n)`
* `:nth-of-type(n)`
* `:nth-last-of-type(n)`
* `:first-child`
* `:last-child`
* `:first-of-type`
* `:last-of-type`
* `:only-child`
* `:only-of-type`
* `:empty`

You can use CSS selectors using the methods `css` and `at_css` on an instance of
`Oga::XML::Document` or `Oga::XML::Element`. For example:

    document = Oga.parse_xml('<people><person>Alice</person></people>')

    document.css('people person') # => NodeSet(Element(name: "person" ...))

The architecture behind this is quite similar to parsing XPath. There's a lexer
(`Oga::CSS::Lexer`) and a parser (`Oga::CSS::Parser`). Unlike Nokogiri (and
perhaps other libraries) the parser _does not_ output XPath expressions as a
String or a CSS specific AST. Instead it directly emits an XPath AST. This
allows the resulting AST to be directly evaluated by `Oga::XPath::Evaluator`.

See <https://github.com/YorickPeterse/oga/issues/11> for more information.

### Mutli-line Attribute Support

Oga can now lex/parse elements that have attributes with newlines in them.
Previously this would trigger memory allocation errors.

See <https://github.com/YorickPeterse/oga/issues/58> for more information.

### SAX after_element

The `after_element` method in the SAX parsing API now always takes two
arguments: the namespace name and element name. Previously this method would
always receive a single nil value as its argument, which is rather pointless.

See <https://github.com/YorickPeterse/oga/issues/54> for more information.

### XPath Grouping

XPath expressions can now be grouped together using parenthesis. This allows one
to specify a custom operator precedence.

### Enumerator Parsing Input

Enumerator instances can now be used as input for `Oga.parse_xml` and friends.
This can be used to download and parse XML files on the fly. For example:

    enum = Enumerator.new do |yielder|
      HTTPClient.get('http://some-website.com/some-big-file.xml') do |chunk|
        yielder << chunk
      end
    end

    document = Oga.parse_xml(enum)

See <https://github.com/YorickPeterse/oga/issues/48> for more information.

### Removing Attributes

Element attributes can now be removed using `Oga::XML::Element#unset`:

    element = Oga::XML::Element.new(:name => 'foo')

    element.set('class', 'foo')
    element.unset('class')

### XPath Attributes

XPath predicates are now evaluated for every context node opposed to being
evaluated once for the entire context. This ensures that expressions such as
`descendant-or-self::node()/foo[1]` are evaluated correctly.

### Available Namespaces

When calling `Oga::XML::Element#available_namespaces` the Hash returned by
`Oga::XML::Element#namespaces` would be modified in place. This was a bug that
has been fixed in this release.

### NodeSets

NodeSet instances can now be compared with each other using `==`. Previously
this would always consider two instances to be different from each other due to
the usage of the default `Object#==` method.

### XML Entities

XML entities such as `&amp;` and `&lt;` are now encoded/decoded by the lexer,
string and text nodes.

See <https://github.com/YorickPeterse/oga/issues/49> for more information.

### General

Source lines are no longer included in error messages generated by the XML
parser. This simplifies the code and removes the need of re-reading the input
(in case of IO/Enumerable inputs).

### XML Lexer Newlines

Newlines in the XML lexer are now counted in native code (C/Java). On MRI and
JRuby the improvement is quite small, but on Rubinius it's a massive
improvement. See commit `8db77c0a09bf6c996dd2856a6dbe1ad076b1d30a` for more
information.

### HTML Void Element Performance

Performance for detecting HTML void elements (e.g. `<br>` and `<link>`) has been
improved by removing String allocations that were not needed.

## 0.1.3 - 2014-09-24

This release fixes a problem with serializing attributes using the namespace
prefix "xmlns". See <https://github.com/YorickPeterse/oga/issues/47> for more
information.

## 0.1.2 - 2014-09-23

### SAX API

A SAX parser/API has been added. This API is useful when even the overhead of
the pull-parser is too much memory wise. Example:

    class ElementNames
      attr_reader :names

      def initialize
        @names = []
      end

      def on_element(namespace, name, attrs = {})
        @names << name
      end
    end

    handler = ElementNames.new

    Oga.sax_parse_xml(handler, '<foo><bar></bar></foo>')

    handler.names # => ["foo", "bar"]

### Racc Gem

Oga will now always use the Racc gem instead of the version shipped with the
Ruby standard library.

### Error Reporting

XML parser errors have been made a little bit more user friendly, though they
can still be quite cryptic.

### Serializing Elements

Elements serialized to XML/HTML will use self-closing tags whenever possible.
When parsing HTML documents only HTML void elements will use self-closing tags
(e.g. `<link>` tags). Example:

    Oga.parse_xml('<foo></foo>').to_xml        # => "<foo />"
    Oga.parse_html('<script></script>').to_xml # => "<script></script>"

### Default Namespaces

Namespaces are no longer removed from the attributes list when an element is
created.

Default XML namespaces can now be registered using `xmlns="..."`. Previously
this would be ignored. Example:

    document = Oga.parse_xml('<root xmlns="baz"></root>')
    root     = document.children[0]

    root.namespace # => Namespace(name: "xmlns" uri: "baz")

### Lexing Incomplete Input

Oga can now lex input such as `</` without entering an infinite loop. Example:

    Oga.parse_xml('</') # => Document(children: NodeSet(Text("</")))

### Absolute XPath Paths

Oga can now parse and evaluate the XPath expression "/" (that is, just "/").
This will return the root node (usually a Document instance). Example:

    document = Oga.parse_xml('<root></root>')

    document.xpath('/') # => NodeSet(Document(children: NodeSet(Element(name: "root"))))

### Namespace Ordering

Namespaces available to an element are now returned in the correct order.
Previously outer namespaces would take precedence over inner namespaces, instead
of it being the other way around. Example:

    document = Oga.parse_xml <<-EOF
    <root xmlns:foo="bar">
      <container xmlns:foo="baz">
        <foo:text>Text!</foo:text>
      </container>
    </root>
    EOF

    foo = document.at_xpath('root/container/foo:text')

    foo.namespace # => Namespace(name: "foo" uri: "baz")

### Parsing Capitalized HTML Void Elements

Oga is now capable of parsing capitalized HTML void elements (e.g. `<BR>`).
Previously it could only parse lower-cased void elements. Thanks to Tero Tasanen
for fixing this. Example:

    Oga.parse_html('<BR>') # => Document(children: NodeSet(Element(name: "BR")))

### Node Type Method Removed

The `node_type` method has been removed and its purpose has been moved into
the `XML::PullParser` class itself. This method was solely used by the pull
parser to provide shorthands for node classes. As such it doesn't make sense to
expose this as a method to the outside world as a public method.

## 0.1.1 - 2014-09-13

This release fixes a problem where element attributes were not separated by
spaces. Thanks to Jonathan Rochkind for reporting it and Bill Dueber providing
an initial patch for this problem.

## 0.1.0 - 2014-09-12

The first public release of Oga. This release contains support for parsing XML,
basic support for parsing HTML, support for querying documents using XPath and
more.
