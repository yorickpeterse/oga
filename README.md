# Oga

Oga is (or will be) a pure Ruby, thread-safe HTML (and XML in the future)
parser that doesn't trigger segmentation faults on Ruby implementations other
than MRI. Oga will initially **not** focus on performance but instead will
focus on proper handling of encodings, stability and a sane API. More
importantly it will be pure Ruby **only**. No C extensions, no Java, no x86 64
assembly, just Ruby.

From [Wikipedia][oga-wikipedia]:

> Oga: A large two-person saw used for ripping large boards in the days before
> power saws. One person stood on a raised platform, with the board below him,
> and the other person stood underneath them.

## Planned Features

* Full support for HTML(5)
* Full support for XML, DTDs will probably be ignored.
* Support for xpath and CSS selector based queries
* SAX/pull parsing APIs that don't make you want to cut yourself

## Features

* A README

## Requirements

* Ruby

Development requirements:

* Ragel
* Racc
* Other stuff

## Usage

Basic DOM parsing example:

    require 'oga'

    parser   = Oga::Parser::DOM.new
    document = parser.parse('<p>Hello</p>')

    puts document.css('p').first.text # => "Hello"

Pull parsing:

    require 'oga'

    parser = Oga::Parser::Pull.new('<p>Hello</p>')

    parser.each do |node|
      puts node.text
    end

These examples will probably change once I actually start writing some code.

## Why Another HTML/XML parser?

Currently there are a few existing parser out there, the most famous one being
[Nokogiri][nokogiri]. Another parser that's becoming more popular these days is
[Ox][ox]. Ruby's standard library also comes with REXML.

The sad truth is that these existing libraries are problematic in their own
ways. Nokogiri for example is extremely unstable on Rubinius. On MRI it works
because of the non conccurent nature of MRI, on Jruby it works because it's
implemented as Java. Nokogiri also uses libxml2 which is a massive beast of a
library, is not thread-safe and problematic to install on certain platforms
(apparently). I don't want to compile libxml2 every time I install Nokogiri
either.

To give an example about the issues with Nokogiri on Rubinius (or any other
Ruby implementation that is not MRI or JRuby), take a look at these issues:

* https://github.com/rubinius/rubinius/issues/2957
* https://github.com/rubinius/rubinius/issues/2908
* https://github.com/rubinius/rubinius/issues/2462
* https://github.com/sparklemotion/nokogiri/issues/1047
* https://github.com/sparklemotion/nokogiri/issues/939

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

Oga is an attempt at solving this problem. By writing it in pure Ruby the
initial performance will probably not be as great. However, I feel this is a
problem with individual Ruby implementations, not the language itself. Also, by
writing it in Ruby we don't have to deal with all the crazy things of C/C++ or
even Java.

In theory it should also allow it to run on every Ruby implementation, be it
JRuby, Rubinius, Topaz or even mruby.

## Donations

<img src="doge.png" align="right" />

Writing an XML/HTML parser is a lot of work. If you feel generous enough you
can reward my work by donating some [Dogecoin][dogecoin] to address
`DUN6ACHZefdroMkwvkyoQD67ZeTac6pJpz`. If you'd like to reward me using a real
currency (such as Monopoly money, aka Euros) you can send it to Paypal
address `yorickpeterse@gmail.com`.

## License

All source code in this repository is licensed under the MIT license unless
specified otherwise. A copy of this license can be found in the file "LICENSE"
in the root directory of this repository.

[nokogiri]: https://github.com/sparklemotion/nokogiri
[oga-wikipedia]: https://en.wikipedia.org/wiki/Japanese_saw#Other_Japanese_saws
[ox]: https://github.com/ohler55/ox
[dogecoin]: http://dogecoin.com/
