# Changelog

This document contains details of the various releases and their release dates.
Dates are in the format `yyyy-mm-dd`.

## 2.11 - 2017-09-07

Various Ruby warnings have been resolved by Loic Nageleisen. See pull request
<https://github.com/YorickPeterse/oga/pull/180> for more information.

## 2.10 - 2017-04-18

### Fix `Element#attribute` for HTML documents when using Symbol arguments

You can now pass a Symbol to `Oga::XML::Element#attribute` for both XML and HTML
documents, previously this only worked for XML documents. See
[PR #174](https://github.com/YorickPeterse/oga/pull/174) for more information.

## 2.9 - 2017-02-10

### Closing tags for HTML void elements

Certain HTML elements such as `<img>` and `<link>` (called "void elements" in
Oga) are now closed using a `>` tag instead of `/>`. In other words, instead of
outputting `<img src="..." />` Oga now outputs `<img src="...">`.

### Doctypes are now Nodes

Each Doctype now inherits from `Oga::XML::Node`. This makes it possible to parse
documents where a doctype is located in a child node. However, in these cases
Oga will _not_ populate `Oga::XML::Document#doctype` as this can not be done in
an efficient way.

## 2.8 - 2017-01-04

Ruby 2.4 deprecates Fixnum in favour of Integer, producing warnings whenever
Fixnum is used. Oga 2.8 contains a fix contributed by Po Shan Cheah to remove
these deprecation warnings. See commit c75ca96d229a50b369e16057622255a674f2cabc
for more information.

## 2.7 - 2016-09-27

### Closing Elements When Generating XML

When generating XML Oga now properly closes elements with siblings but without
children. See commit e0e0687dc29427c854c9fa6d3c19cee1c04f92c7 for more
information.

### Newlines After Doctypes

When generating XML a newline would be inserted after a doctype. If another
newline would follow in a text node this would lead to multiple newlines being
present. Oga now ensures there is only 1 newline following a doctype. See commit
e0e0687dc29427c854c9fa6d3c19cee1c04f92c7 for more information.

### Processing Instructions With Namespace Prefixes

The XML lexer now supports processing instructions containing namespace prefixes
such as `<?xml:foo ?>`. See commit 01fa1513f4bd6f194bf6d1ca17e510003fa23312 for
more information.

### XML Declarations Are Now Processing Instructions

The class `Oga::XML::XmlDeclaration` now extends
`Oga::XML::ProcessingInstruction`. This allows documents to contain XML
declarations in nested elements, instead of only allowing this at the root of
the document. See commit 116b9b0ceb6feab4daa0bb417302590fba948bef for more
information.

### Aliases For Getting & Setting Attributes

The methods `Oga::XML::Element#get` and `Oga::XML::Element#set` are now aliased
as `#[]` and `#[]=` respectively. See d40baf0c724a3874f43100fbefa775cfb8dcacda
for more information and thanks to Scott Wheeler for contributing the patch.

## 2.6 - 2016-09-10

This release fixes a bug in the XML generation code that would cause it to get
stuck in the generation loop. See issue
<https://github.com/YorickPeterse/oga/issues/161> and commit
38284278d542640c3d8300ef15890af93b6df779 for more information.

## 2.5 - 2016-09-06

This release fixes a bug in the XML parser that would prevent it from parsing
doctypes that contain a mixture of public/system IDs, a name, and inline rules.

See issue <https://github.com/YorickPeterse/oga/issues/159> and commit
68f1f9f660b90a43d22c8514e8cbf53f7ca0097d for more information.

## 2.4 - 2016-09-04

### Serialising Large Documents

Oga can now serialise large documents without causing the call stack to overflow
thanks to the new `Oga::XML::Generator` class. This class can generate XML
without using a stack at all.

See issue <https://github.com/YorickPeterse/oga/issues/158> and commit
dd138981f68a606eff5d5a01e990f04398087dc4 for more information.

### Faster retrieval of previous/next nodes

The methods `Oga::XML::Node#previous` and `Oga::XML::Node#next` now simply
return the value of an instance variable instead of calculating the
previous/next node on the fly. This greatly improves the performance of these
methods at the cost of a bit of extra work when adding or removing nodes from a
NodeSet.

See commit 5a58b1413767fed4518e8a67c4eb432a31592660 for more information.

## 2.3 - 2016-07-13

Thanks to various changes provided by Erik Michaels-Ober Oga can now be used to
parse XML input from a pipe (as returned by for example `IO.pipe`). See the
following pull request for more information:
<https://github.com/YorickPeterse/oga/pull/154>.

## 2.2 - 2016-02-23

### XPath support for nested pipe operators

Nested pipe operators such as `a | b | c` are now supported as XPath
expressions. See issue <https://github.com/YorickPeterse/oga/issues/149> and
commit 6d3c5c2ce93cbce337338bdc1a4971da72517038 for more information.

## 2.1 - 2016-02-09

### Preserving entities that can't be decoded

Decoding of invalid XML/HTML entities now results in these entities being
preserved as-is, instead of raising an EncodingError in certain places. See
<https://github.com/YorickPeterse/oga/issues/143> and commit
5bfc2d50f2a3d387cb9fc28826d1f3d5a2d9d224 for more information.

### New Versioning Format

Starting with this release the patch number is dropped from the version. This
means version numbers are now in the format `MAJOR.MINOR`. See the README for
more information.

## 2.0.0 - 2015-12-26

### Fixed parsing HTML identifiers

HTML identifiers are now parsed correctly. This means that for the element
`<foo:bar />` the element name is now "bar" _without_ a namespace prefix ever
being set. For the element `<foo bar:baz="10" />` the attribute name is now
"bar:baz" instead of just "baz".

This particular change may break existing applications, hence the version bump
to 2.0.

See commit 66fc4b1dfcc4b651302c7582f62287d5750dcbfe for more information.

### Slightly improved performance of checking XPath booleans

Performance of checking if certain XPath values are booleans has been improved
somewhat. See commit 9bb908f8b1f6c72582ae6070d30f8bd8316ec5ad for more
information.

## 1.3.1 - 2015-09-07

### Race condition in the XPath compiler

This release fixes a race condition in the XPath compiler. The
`XPath::Compiler#compile` method would compile Procs using its own Binding, this
in turn would lead to race conditions when using the compiled Procs
concurrently.

See commit bd48dc15cc26f4eb556068afaafd2ab18271d8d3 for more information.

## 1.3.0 - 2015-09-06

### XPath query evaluation rewritten

The system used for evaluating XPath and CSS queries has been rewritten from the
ground up, resulting in much better performance. Prior to 1.3.0 Oga would
evaluate queries by iterating over the Abstract Syntax Tree (AST) produced by
the XPath/CSS parser. This setup could lead to _lots_ of object allocations and
method calls, even for small queries.

Starting with 1.3.0 Oga instead generates Ruby code based on XPath expressions.
The generated code relies on nesting of conditionals (instead of method calls)
and allocates far fewer objects (partially as a result of this). The generated
code is cached based on the input expression, removing the need for recompiling
the same expression over and over. The result of all this greatly improved
querying performance.

As an example, lets look at the benchmark
`benchmark/xpath/compiler/big_xml_average_bench.rb`. When using Oga 1.2.3 the
output is as following:

    Iteration: 1: 3.292
    Iteration: 2: 2.71
    Iteration: 3: 2.747
    Iteration: 4: 2.752
    Iteration: 5: 2.776
    Iteration: 6: 2.735
    Iteration: 7: 2.761
    Iteration: 8: 2.741
    Iteration: 9: 2.791
    Iteration: 10: 2.787

    Iterations: 10
    Average:    2.809 sec

Using Oga 1.3.0 we instead get the following output:

    Iteration: 1: 0.639
    Iteration: 2: 0.422
    Iteration: 3: 0.428
    Iteration: 4: 0.47
    Iteration: 5: 0.443
    Iteration: 6: 0.445
    Iteration: 7: 0.51
    Iteration: 8: 0.485
    Iteration: 9: 0.506
    Iteration: 10: 0.547

    Iterations: 10
    Average:    0.489 sec

Here Oga 1.3.0 is about 5.7 times faster compared to version 1.2.3.

In the coming days I'll work on writing a blog post that explains more about the
new compiler setup, how it works, how it performs, etc.

In the mean time, see the following issues/pull requests for more information:

* <https://github.com/YorickPeterse/oga/issues/102>
* <https://github.com/YorickPeterse/oga/pull/138>

### Escaping of characters in CSS expressions

CSS expressions now allow querying of nodes having dots in the element name or
namespace. This can be done by escaping the dot using a backslash. For example:

    Oga.parse_xml('<foo.bar />').css('foo\.bar') # => NodeSet(Element(name: "foo.bar"))

See issue <https://github.com/YorickPeterse/oga/issues/124> for more
information.

### Support for the CSS :not() pseudo class

CSS expressions can now use the `:not()` pseudo class.

See issue <https://github.com/YorickPeterse/oga/issues/125> for more
information.

### Improved parsing of CSS expressions

CSS expressions such as `foo>bar` and `foo > .bar` are now supported, previously
these would result in parser errors.

See the following issues for more information:

* <https://github.com/YorickPeterse/oga/issues/126>
* <https://github.com/YorickPeterse/oga/issues/131>

### Unicode support for CSS/XPath

CSS and XPath expressions can now contain Unicode characters, previously only
ASCII characters were allowed for identifiers (node tests, attribute names,
etc).

See issue <https://github.com/YorickPeterse/oga/issues/140> for more
information.

## 1.2.3 - 2015-08-19

### NodeSet performance improvements

Performance of the NodeSet class has been improved, especially when used in
concurrent environments. See commit 4f94d03a85f6acabe5cc57ba8c778928e42186be for
more information.

### Comparing names in the XPath evaluator

Performance of comparing names of nodes in the XPath evaluator has been
improved thanks to Daniel Fockler.

See the following commits for more information:

* be7bc8f4234832ea16385ed92ba252850d7a890e
* fc38b39aa36f49fc38afd44c7e23ac3bfc6159e7
* 496811a23fa7c3f0498ec5721575b1c8406a5351

## 1.2.2 - 2015-08-14

### Race condition in the LRU class

A race condition in the LRU class has been resolved. This race condition would
result in errors such as "ConcurrencyError: Detected invalid array contents due
to unsynchronized modifications with concurrent users" on JRuby or
"ArgumentError: negative array size" on Rubinius.

See commit 32b75bf62c0c1770b68e7e1a9918718943d1c04c for more information.

### Lexing of void elements with explicit closing tags

Void elements followed by an explicit closing tag (e.g. `<param></param>`) are
now lexed properly. Thanks to Jakub Pawlowicz for fixing this.

See commit ed3cbe7975eeb9d142c4f649334038b6389abc0e for more information.

## 1.2.1 - 2015-07-01

### Better support for decoding unrecognized XML/HTML entities

Jakub Pawlowicz improved the process of decoding XML/HTML entities so that it
handles unrecognized entities better. Previously Oga would raise an error when
trying to decode entities such as `&#TAB;` instead of just leaving them as-is.

See issue <https://github.com/YorickPeterse/oga/issues/118> and pull request
<https://github.com/YorickPeterse/oga/pull/122> for more information.

## 1.2.0 - 2015-06-30

### Support for Unicode in XML/HTML identifiers

XML/HTML element and attribute names can now contain Unicode characters. While
the HTML specification states only ASCII may be used Oga still supports Unicode
identifiers for HTML.

See commit dde644cd7991f5d24e662e0fc4094bd644274046 for more information.

### Support for dots in XML/HTML identifiers

XML/HTML element and attribute names can now contain dots such as
`<foo.bar>baz</foo.bar>`. Thanks to Laurence Lee for adding this.

See commit b7771ed5fe4b82ad72d255444f87f5e51638af7d for more information.

### Support for the CSS :nth() pseudo class

Oga now supports the `:nth()` CSS pseudo class. This pseudo class can be used to
select the Nth element in a set regardless of any preceding/following siblings.

See commit 71960fff87da633dcab863002a461fbf7d4c5738 for more information.

### Support for commas in CSS expressions

CSS expressions such as `foo, bar` and `#hello, #world` are now supported.

See commit d26b48feb454de0d5b2a3a9bcffaa7c5d9d604b5 for more information.

## 1.1.0 - 2015-06-29

### Better support for unquoted HTML attribute values

Oga can now parse HTML such as `<a href=foo("bar","baz")></a>` and basically any
other kind of value as long as it does not contain a `>` or whitespace.

See commit 3b633ff41c48c44893e42d3ba29ef7a5e3d70617 for more information.

### Support for replacing of DOM nodes

The newly added method `Oga::XML::Node#replace` can be used to replace an
existing node with another node or with a String (which will result in it being
replaced with a Text node). For example:

    p   = Oga::XML::Element.new(:name => 'p')
    div = Oga::XML::Element.new(:name => 'div', :children => [p])

    puts div.to_xml # => "<div><p /></div>"

    p.replace('Hello world!')

    puts div.to_xml # => "<div>Hello world!</div>"

Thanks to Tero Tasanen for adding this.

See commit 0b4791b277abf492ae0feb1c467dfc03aef4f2ec and
<https://github.com/YorickPeterse/oga/pull/116> for more information.

### Encoding quotes in attribute values

When serializing elements back to XML Oga now properly encodes single/double
quotes in attribute values. See commit 074b53c18c85eaeba09557f6b0c5a6792f522c3e
for more information.

## 1.0.3 - 2015-06-16

### Strict XML parsing support

Oga can now parse XML documents in "strict mode". This mode currently only
disables the automatic insertion of missing closing tags. This feature can be
used as following:

    document = Oga.parse_xml('<foo>bar</foo>', :strict => true)

This works for all 3 (DOM, SAX and pull) parsing APIs.

See commit 2c18a51ba905d46469170af7f071b068abe965eb for more information.

### Support for HTML attribute values without starting quotes

Oga can now parse HTML such as `<foo bar=baz" />`. This will be parsed as if the
input were `<foo bar='baz"' />`.

See commit fd307a0fcc3616ded272432ba27f972a9113953a for more information.

### Support for spaces around attribute equal signs

Previously XML/HTML such as `<foo bar = "baz" />` would not be parsed correctly
as Oga didn't support spaces around the `=` sign. Commit
a76286b973ed6d6241a0280eb3d1d117428e9964 added support for input like this.

### Decoding entities with numbers

Oga can now decode entities such as `&frac12;`. Due to an incorrect regular
expression these entities would not be decoded.

See commit af7f2674af65a2dd50f6f8a138ddd9429e8533d1 for more information.

## 1.0.2 - 2015-06-03

### Fix for requiring extensions on certain platforms

The loading of files has been changed to use `require` so that native extensions
are loaded properly even when a platform decides not to store in in the lib
directory.

See commit 4bfeea2590682ce7bf721c1305cb7c7a5707faac for more information.

### Better closing of HTML tags

Closing of HTML tags has been improved so Oga can parse HTML such as this:

    <div>
        <ul>
            <li>foo
        </ul>
        inside div
    </div>
    outside div

See the following commits for more information:

* d0d597e2d93035c35b6b653d181f550d9dd522fd
* 5182d0c488759efb96d85a399de29550faea3efe
* 3c6263d8de30b91aac7c3b16b65f00407b88fc13

### Whitespace support in closing tags

Oga can now lex HTML/XML such as the following:

    <p>hello<p
    >

See commit d2523a1082b5ab601724e02fa4c613a9d9d9e3c6 for more information.

## 1.0.1 - 2015-05-21

### Encoding quotes in XML

Oga no longer encodes single/double quotes as XML entities when serializing a
document back to XML. This ensures that input such as `<foo>a"b</foo>` doesn't
get turned into `<foo>a&quot;b</foo>`.

### HTML Entity Encoding

HTML entities are now generated using `pack('U*')` instead of `pack('U')`
ensuring the correct characters/codepoints are produced.

## 1.0.0 - 2015-05-20

This marks the first stable release (API wise) for Oga. It's been quite the ride
since the very first commit from February 26, 2014. In the releases following
1.0 I plan to focus mainly on performance as both XMl/HTML parsing and XPath
evaluation performance is not quite as fast as I'd like it to be.

### License Change

Up until 1.0.0 Oga was licensed under the MIT license. Since this license does
fairly little to protect authors (especially regarding patents) I've decided to
change the license to the Mozilla Public License 2.0. More information on this
can be found in commit 0a7242aed44fcd7ef18327cc5b10263fd9807a35.

### XPath Performance Improvements

With 1.0 the evaluator received further performance improvements that should be
especially noticable when querying large XML/HTML documents. Improving XPath
performance is an ongoing task so expect similar improvements in upcoming
releases.

See the following commits for more information:

* ecdeeacd767ec974e7cf2306f30d62bf7c3120b8
* 5c7c4a6110d9fc7142bccc367f8b77b98532eac4
* 0298e7068c79a46aef6dc8256ccc25348d2bdf1d
* b9145d83f8ac97d813cabc3837488a0d732893fd
* b5e63dc50eb8423a1839fbfb815521e8f3a1e378

### Full HTML5 Support

With 1.0 Oga finally supports parsing of HTML5 according to the official
specification. This means that Oga is now capable of parsing HTML such as the
following:

    <p>Hello, this is a list:</p>

    <ul>
        <li>First item
        </li>Second item
    </ul>

This would be parsed as if the HTML were as following instead:

    <p>Hello, this is a list:</p>

    <ul>
        <li>First item</li>
        </li>Second item</li>
    </ul>

See the following commits for more information:

* 688a1fff0efb9e2405e0aab5b3a7164e78ec287e
* 1c095ddaffd7e33cc89449d77a1cc25a781f8a92
* 1e0b7feb026d95f2b04706391a868d64b7e5de6e
* 69180ff686553958eeedecf1d89a9e6a56d7571e
* 4b1c296936c02854247fbc0814a005f05b7eec0e
* 4b21a2fadc8684446663d92c7b73be46595323c1
* 8135074a62c38b039fbee2d916a196e1e43039f3

The following issues are also worth checking out:

* https://github.com/YorickPeterse/oga/issues/101
* https://github.com/YorickPeterse/oga/issues/99

### Handling of invalid XML/HTML

Oga can now handle most forms of invalid XML/HTML by automatically inserting
missing closing tags and ignoring stray opening tags where possible. This allows
Oga to parse XML such as the following:

    <root>
        <person>
            <name>Alice</name>
        </person>

See commit 13e2c3d82ffb9f32b863cb47f6808cf061e07095 for more information.

### Decoding zero padded XML/HTML entities

Oga can now decode zero padded XML/HTML entities such as `&#038;`. See commit
853d804f3468c9f54c222568a7faedf736f8dc1a for more information.

## 0.3.4 - 2015-04-19

XML and HTML entities are decoded in the SAX parser before data is passed to a
custom handler class.

See commit da62fcd75d0889e4539e7390777a906a914a78c0 for more information.

## 0.3.3 - 2015-04-18

### Improved lexer support for script/style tags

Commit 73fbbfbdbdecafcf5f873b8a27e81c19a2e2ed0c improved support for lexing
HTML script and style tags, ensuring that HTML such as the following is
processed correctly:

    <script>
    var foo = "</style>"
    </script>

    <style>
    /* </script> */
    </style>

### Lexing of extra quotes

The XML lexer can now handle stray quotes that reside in the open tag of an
element, for example:

    <a href="foo""></a>

While technically invalid HTML certain websites such as <http://yahoo.com>
contain HTML like this.

See commit 6b779d788384b89ba30ef60c17a156216ba5b333 for more information.

### Lexing of doctypes containing newlines

The XML lexer is now capable of lexing doctypes that contain newlines such as:

    <!DOCTYPE
        html>

See commit 9a0e31d0ae9fc8bbf9fdacb13100a7327d09157a for more information.

## 0.3.2 - 2015-04-15

### Support for unquoted HTML attribute values

Oga can now lex/parse HTML attribute values that don't use quotes. For example,
the following is valid HTML:

    <a href=foo>Foo</a>

And so is this:

    <a href=foo/bar>Foo/bar</a>

See Github issue <https://github.com/YorickPeterse/oga/issues/94> and the
following commits for more information:

* bc9b9bc9537d9dc614b47323e0a6727a4ec2dd04
* d892ce97874ed0f1382df993c40a452530025f02
* afbb5858122d5aece252b957b3988787ed76168f
* 23a441933ac659933646418ed62ba188bb20ff65

### Counting newlines in XML declarations

The XML lexer has been adjusted so that it counts newlines when processing
XML declarations. While these newlines are not exposed to the resulting
`Oga::XML::*` instances they are used when reporting errors. Previously the
lexer wouldn't count newlines in XML declarations, leading to error messages
referring to incorrect line numbers.

This was fixed in commit e942086f2df0204fc7756c3df260297f5cadc7c2.

### Better lexer support for CDATA, comments and processing instructions

The XML lexer has been tweaked so it can handle multi-line CDATA tags, comments
and processing instructions, both when using a String and IO (or similar) as
input.

See Github issue <https://github.com/YorickPeterse/oga/issues/93> and the
following commits for more information:

* b2ea20ba615953254554565e0c8b11587ac4f59c
* ea8b4aa92fe746a9da19e94c3edf68b41495d992
* 8acc7fc743c9492eed2d9c885c22c1b5bec06d0f

### Performance Improvements

To improve performance of the XPath evaluator (as well as generic code using
Oga) the following methods now cache their return values:

* `Oga::XML::Element#available_namespaces`
* `Oga::XML::Element#namespace`
* `Oga::XML::Node#html?`

These cache of these methods is flushed automatically when needed. For example,
registering a new namespace will flush the cache for
`Element#available_namespaces` and `Element#namespace`.

The performance of `Oga::XML::Traversal#each_node` has also been optimized,
cutting down the amount of object allocations significantly.

Combined these improvements should make XPath evaluation roughly 4 times faster.

See the following commits for more information:

* 739e3b474cb562f774a0e80f5f33b3b18ec7d8c5
* b42f9aaf322c6bb67a3ddfd2b350d72a45c1fd8f
* fa838154fc19c938355e1d96c5e2dd4d8c299ba3
* b0359b37e536aef172b95b54dea91198b9512e15

## 0.3.1 - 2015-04-08

Oga no longer decodes any HTML entities that appear inside the body of a
`<script>` or `<style>` tag. For example, this HTML:

    <script>foo&bar;</script>

Would effectively be turned into:

    <script>foo</script>

See commit 4bdc8a3fdcc3111c1e2f7de983faaaf5bb6fffb1 for more information.

## 0.3.0 - 2015-04-03

### Lexing of carriage returns

Oga can now lex and parse XML documents using carriage returns for newlines.
This was added in commit 0800654c962c20fb139a389245359bca9952dcd1.

### Improved handling of HTML namespaces

Oga now ignores any declared namespaces when parsing HTML documents as HTML5
does not allow one to register custom namespaces.

See commit 31764593070b29fcd16040a6a0bd553e464324cd for more information.

### Improved handling of explicitly declared default XML namespaces

In the past explicitly defining the default XML namespace in a document would
lead to Oga's XPath evaluator not being able to match any nodes. This has been
fixed in commit 5adeae18d0e53fda3bcfb883b414dee8e3a9d87d.

### Caching of XPath/CSS expressions

The CSS and XPath parsers now cache the ASTs of an expression used when querying
a document using CSS or XPath. This can give a pretty noticable speed
improvement, especially when running the same expression in a loop (or just many
different times).

Parsed expressions are stored in an LRU to prevent memory from growing forever.
Currently the capacity is set to 1024 values but this can be changed as
following:

    Oga::XPath::Parser::CACHE.maximum = 2048
    Oga::CSS::Parser::CACHE.maximum   = 2048

The LRU synchronizes method calls to allow safe usage from multiple threads.

See the following commits for more info:

* 66fa9f62ef1f5e2e447cdc724b42f2e1d58b0753
* 12aa21fb502a044d660cc53557d0a1208eb8e61d
* 2c4e490614528dc873f8275fe10c34ae489cfee5
* 67d7d9af88787a8a810273e3451b194a6284b1ef

### Windows support

While Oga for the most part already supported Windows a few changes for the
extension compilation process were required to allow users to install Oga on
Windows. Tests are run on AppVeyor (a continuous integration service for Windows
platforms).

Oga requires devkit (<http://rubyinstaller.org/add-ons/devkit/>) to be installed
on non Cygwin/MinGW environments. Cygwin/MinGW environments probably already
work, although I do not run any tests on these environments.

### SAX parsing of XML attributes

Parsing of XML attributes using the SAX API was overhauled quite a bit. As these
changes are not backwards compatible it's likely that existing SAX parsers will
break.

See commit d8b9725b82f93d92b10170612446fbbef6190fda for more information.

### Parser callbacks for XML attributes

The XML parser has an extra callback method called `on_attribute` which is used
to create a new attribute. This callback can be used in custom SAX parsers just
like the other callbacks.

### Parser rewritten using ruby-ll

The XML, CSS and XPath parsers have been re-written using ruby-ll
(<https://github.com/yorickpeterse/ruby-ll>). While Racc served its purpose
(until now) it has three main problems:

1. Performance is not as good as it should be.
2. The codebase is dated and generally hard to deal with, as such it's quite
   difficult to optimize in reasonable time.
3. LALR parser errors can be incredibly painful to debug.

For this reason I wrote ruby-ll and replaced Oga's Racc based parsers with
ruby-ll parsers. These parsers are LL(1) parsers which makes them a lot easier
to debug. Performance is currently a tiny bit faster than the old Racc parsers,
but this will be improved in the coming releases of both Oga and ruby-ll.

See pull request <https://github.com/YorickPeterse/oga/pull/78> for more
information.

### Lazy decoding of XML/HTML entities

In the past XML/HTML entities were decoded in the lexer, adding overhead even
when not needed. This has been changed so that the decoding of entities only
occurs when calling `XML::Text#text`. With this particular change also comes
support for HTML entities and codepoint based XML/HTML entities.

See commit 2ec91f130fcdfee918578d045b07367aec434260 for more information.

## 0.2.3 - 2015-03-04

This release adds support for lexing HTML `<style>` tags similar to how
`<script>` tags are handled. This ensures that the contents of these tags are
treated as-is without any HTML entity conversion being applied.

See commits 78e40b55c0e5941bee5791a5014260e9c2cf8aad and
3b2055a30b128aa679a83332dfdfa68314271b24 for more information.

## 0.2.2 - 2015-03-03

This release fixes a bug where setting the text of an element using
`Oga::XML::Element#inner_text=` would not set the parent element of the newly
created text node. This would result in the following:

    some_element.inner_text = 'foo'

    some_element.children[0].parent # => nil

Here `parent` is supposed to return `some_element` instead. See commit
142b467277dc9864df8279347ba737ddf60f4836 for more information.

## 0.2.1 - 2015-03-02

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
