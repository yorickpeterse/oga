# Changelog

This document contains details of the various releases and their release dates.
Dates are in the format `yyyy-mm-dd`.

## 0.2.0 - Unreleased

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
