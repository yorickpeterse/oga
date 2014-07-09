# Contributing

Everybody is more than welcome to contribute to Oga, no matter how small the
change. To keep everything running smoothly there are a few guidelines that one
should follow. These are as following:

* When changing code make sure to write RSpec tests for the changes.
* Document code using YARD. At the very least the method arguments and return
  value(s) should be documented.
* Wrap lines at 79 characters per line.
* Git commits should have a <= 50 character summary, optionally followed by a
  blank line and a more in depth description of 80 characters per line.

## Editor Setup

Whatever editor you use doesn't matter as long as it can do two things:

* Use spaces for indentation.
* Hard wrap lines at 80 characters per line.

To make this process easier Oga comes with an [EditorConfig][editorconfig]
configuration file. If your editor supports this it will automatically apply
the required settings for you.

## Hacking on Oga

Assuming you have a local Git clone of Oga, the first step should be to install
all the required Gems:

    bundle install

Next up, compile the required files and run the tests:

    rake

You can compile the various parsers/extensions by running:

    rake generate

For more information about the available tasks, run `rake -T`.

## Extension Setup

Oga uses native extensions for the XML lexer. This is due to Ruby sadly not
being fast enough to chew through large amounts of XML (at least when using
Ragel). For example, the benchmark `benchmark/lexer/big_xml_time.rb` would take
around 6 seconds to complete on MRI 2.1.1. The native extensions on the other
hand can complete this benchmark in roughly 600 milliseconds.

Oga has two native extensions: one for MRI/Rubinius (written in C) and one for
JRuby (written in Java). Both extensions share the same Ragel grammar, found in
`ext/ragel/base_lexer.rl`. This grammar is set up in such a way that the syntax
is compatible with both C and Java. Specific details on how the grammar is used
can be found in the documentation of said grammar file.

The native extensions call back in to Ruby to actually perform the task of
creating tokens, validating input and so forth. As a result of this you'll most
likely never have to touch the C and/or Java code when changing the behaviour
of the lexer.

To compile the extensions run `rake generate` using your Ruby implementation of
choice. Note that extensions compiled for MRI can not be used on Rubinius and
vice-versa. To compile the JRuby extension you'll have to switch your active
Ruby version to JRuby first.

## Contact

In case you have any further questions or would like to receive feedback before
submitting a change, feel free to contact me. You can either open an issue,
send a tweet to [@yorickpeterse][twitter] or send an Email to
<yorickpeterse@gmail.com>.

## Legal

By contributing to Oga you agree with both the Developer's Certificate of
origin, found in `doc/DCO.md` and the license, found in `LICENSE`. This applies
to all content in this repository unless stated otherwise.

[editorconfig]:http://editorconfig.org/
[twitter]: https://twitter.com/yorickpeterse
