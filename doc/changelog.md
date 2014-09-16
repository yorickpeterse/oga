# Changelog

## 0.2.0 - Unreleased

A SAX parser/API has been added. This API is useful when even the overhead of
the pull-parser is too much memory wise.

Oga will now always use the Racc gem instead of the version shipped with the
Ruby standard library.

XML parser errors have been made a little bit more user friendly, though they
can still be quite cryptic.

Elements serialized to XML/HTML will use self-closing tags whenever possible.
When parsing HTML documents only HTML void elements will use self-closing tags
(e.g. `<link>` tags).

Namespaces are no longer removed from the attributes list when an element is
created.

Default XML namespaces can now be registered using `xmlns="..."`. Previously
this would be ignored.

Oga can now lex input such as `</` without entering an infinite loop.

Oga can now parse and evaluate the XPath expression "/" (that is, just "/").
This will return the root node (usually a Document instance).

Namespaces available to an element are now returned in the correct order.
Previously outer namespaces would take precedence over inner namespaces, instead
of it being the other way around.

Oga is now capable of parsing capitalized HTML void elements (e.g. `<BR>`).
Previously it could only parse lower-cased void elements. Thanks to Tero Tasanen
for fixing this.

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
