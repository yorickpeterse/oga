# Oga

Oga is an XML/HTML parser written in Ruby. Oga aims to provide an easy to use
and high performance API for all your XML/HTML parsing needs. Oga requires
nothing other than Ruby, it does not depend on libxml and the likes.

To achieve high performance Oga uses a C or Java extension depending on your
Ruby platform. Pure Ruby is sadly not fast enough to process large amounts of
text in reasonable time.

From [Wikipedia][oga-wikipedia]:

> Oga: A large two-person saw used for ripping large boards in the days before
> power saws. One person stood on a raised platform, with the board below him,
> and the other person stood underneath them.

## Examples

Parsing a simple string of XML:

    Oga.parse_xml('<people><person>Alice</person></people>')

Parsing a simple string of HTML:

    Oga.parse_html('<link rel="stylesheet" href="foo.css">')

Parsing an IO handle pointing to XML (this also works when using
`Oga.parse_html`):

    handle = File.open('path/to/file.xml')

    Oga.parse_xml(handle)

Parsing an IO handle using the pull parser:

    handle = File.open('path/to/file.xml')
    parser = Oga::XML::PullParser.new(handle)

    parser.parse do |node|
      parser.on(:text) do
        puts node.text
      end
    end

Querying a document using XPath:

    document = Oga.parse_xml('<people><person>Alice</person></people>')

    document.xpath('string(people/person)') # => "Alice"

Modifying a document and serializing it back to XML:

    document = Oga.parse_xml('<people><person>Alice</person></people>')
    name     = document.at_xpath('people/person[1]/text()')

    name.text = 'Bob'

    document.to_xml # => "<people><person>Bob</person></people>"

## Features

* Support for parsing XML and HTML(5)
  * DOM parsing
  * Stream/pull parsing
* High performance and low memory usage (depending on the parsing API)
* Support for XPath 1.0
* CSS selectors support (planned)

## Requirements

| Ruby     | Required      | Recommended |
|:---------|:--------------|:------------|
| MRI      | >= 1.9.3      | >= 2.1.2    |
| Rubinius | >= 2.2        | >= 2.2.10   |
| JRuby    | >= 1.7        | >= 1.7.12   |
| Maglev   | Not supported |             |
| Topaz    | Not supported |             |
| mruby    | Not supported |             |

Maglev and Topaz are not supported due to the lack of a C API (that I know of)
and the lack of active development of these Ruby implementations. mruby is not
supported because it's a very different implementation all together.

To install Oga on MRI or Rubinius you'll need to have a working compiler such as
gcc or clang. Oga's C extension can be compiled with both. JRuby does not
require a compiler as the native extension is compiled during the Gem building
process and bundled inside the Gem itself.

## Native Extension Setup

The native extensions can be found in `ext/` and are divided into a C and Java
extension. These extensions are only used for the XML lexer built using Ragel.
The grammar for this lexer is shared between C and Java and can be found in
`ext/ragel/base_lexer.rl`.

The extensions delegate most of their work back to Ruby code. As a result of
this maintenance of this codebase is much easier. If one wants to change the
grammar they only have to do so in one place and they don't have to worry about
C and/or Java specific details.

For more details on calling Ruby methods from Ragel see the source
documentation in `ext/ragel/base_lexer.rl`.

## Why Another HTML/XML parser?

Currently there are a few existing parser out there, the most famous one being
[Nokogiri][nokogiri]. Another parser that's becoming more popular these days is
[Ox][ox]. Ruby's standard library also comes with REXML.

The sad truth is that these existing libraries are problematic in their own
ways. Nokogiri for example is extremely unstable on Rubinius. On MRI it works
because of the non conccurent nature of MRI, on JRuby it works because it's
implemented as Java. Nokogiri also uses libxml2 which is a massive beast of a
library, is not thread-safe and problematic to install on certain platforms
(apparently). I don't want to compile libxml2 every time I install Nokogiri
either.

To give an example about the issues with Nokogiri on Rubinius (or any other
Ruby implementation that is not MRI or JRuby), take a look at these issues:

* <https://github.com/rubinius/rubinius/issues/2957>
* <https://github.com/rubinius/rubinius/issues/2908>
* <https://github.com/rubinius/rubinius/issues/2462>
* <https://github.com/sparklemotion/nokogiri/issues/1047>
* <https://github.com/sparklemotion/nokogiri/issues/939>

Some of these have been fixed, some have not. The core problem remains:
Nokogiri acts in a way that there can be a large number of places where it
*might* break due to throwing around void pointers and what not and expecting
that things magically work. Note that I have nothing against the people running
these projects, I just heavily, *heavily* dislike the resulting codebase one
has to deal with today.

Ox looks very promising but it lacks a rather crucial feature: parsing HTML
(without using a SAX API). It's also again a C extension making debugging more
of a pain (at least for me).

I just want an HTML parser that I can rely on stability wise and that is
written in Ruby so I can actually debug it. In theory it should also make it
easier for other Ruby developers to contribute.

## License

All source code in this repository is licensed under the MIT license unless
specified otherwise. A copy of this license can be found in the file "LICENSE"
in the root directory of this repository.

[nokogiri]: https://github.com/sparklemotion/nokogiri
[oga-wikipedia]: https://en.wikipedia.org/wiki/Japanese_saw#Other_Japanese_saws
[ox]: https://github.com/ohler55/ox
