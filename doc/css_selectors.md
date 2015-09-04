# CSS Selectors Specification

This document acts as an alternative specification to the official W3
[CSS3 Selectors Specification][w3spec]. This document specifies only the
selectors supported by Oga itself. Only CSS3 selectors are covered, CSS4 is not
part of this specification.

This document is best viewed in the YARD generated documentation or any other
Markdown viewer that supports the [Kramdown][kramdown] syntax. Alternatively it
can be viewed in its raw form.

## Abstract

The official W3 specification on CSS selectors is anything but pleasant to read.
A lack of good examples and unspecified behaviour are just two of many problems.
This document was written as a reference guide for myself as well as a way for
others to more easily understand how CSS selectors work.

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED",  "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119][rfc-2119].

## Syntax

To describe syntax elements of CSS selectors this document uses the same grammar
as [Ragel][ragel]. For example, an integer would be defined as following:

    integer = [0-9]+;

In turn an integer that can optionally be prefixed by `+` or `-` would be
defined as following:

    integer = ('+' | '-')* [0-9]+;

A quick and basic crash course of the Ragel grammar:

* `*`: zero or more instance of the preceding token(s)
* `+`: one or more instances of the preceding token(s)
* `(` and `)`: used for grouping expressions together
* `^`: inverts a match, thus `^[0-9]` means "anything but a single digit"
* `"..."` or `'...'`: a literal character, `"x"` would match the literal "x"
* `|`: the OR operator, `x | y` translates to "x OR y"
* `[...]`: used to define a sequence, `[0-9]` translates to "0 OR 1 OR 2 OR
  3..." all the way upto 9

Semicolons are used to terminate lines. While not strictly required in this
specification they are included in order to produce a Ragel syntax compatible
grammar.

See the Ragel documentation for more information on the grammar.

## Terminology

local name
: The name of an element without a namespace. For the element `<strong>` the
  local name is `strong`.

namespace prefix
: The namespace prefix of an element. For the element `<foo:strong>` the
  namespace prefix is `foo`.

expression
: A single or multiple selectors used together to retrieve a set of elements
  from a document.

## Selector Scoping

Whenever a selector is used to match an element the selector applies to all
nodes in the context. For example, the selector `foo` would match all `foo`
elements at any position in the document. On the other hand, the selector
`foo bar` only matches any `bar` elements that are a descedant of any `foo`
element.

In XPath the corresponding axis for this is `descendant`. In other words, this
CSS expression:

    foo

is the same as this XPath expression:

    descendant::foo

In turn this CSS expression:

    foo bar

is the same as this XPath expression:

    descendant::foo/::bar

Note that in the various XPath examples the `descendant` axis is omitted in
order to enhance readability.

### Syntax

A CSS expression is made up of multiple selectors separated by one or more
spaces. There MUST be at least 1 space between two selectors, there MAY be more
than one. Multiple spaces do not alter the behaviour of the expression in any
way.

## Universal Selector

W3 chapter: <http://www.w3.org/TR/css3-selectors/#universal-selector>

The universal selector `*` (also known as the "wildcard selector") can be used
to match any element, regardless of its local name or namespace prefix.

Example XML:

    <root>
        <foo></foo>
        <bar></bar>
    </root>

CSS:

    root *

This would return a set containing two elements: `<foo>` and `<bar>`

The corresponding XPath is also `*`.

### Syntax

The syntax for the universal selector is very simple:

    universal = '*';

## Element Selector

W3 chapter: <http://www.w3.org/TR/css3-selectors/#type-selectors>

The element selector (known as "Type selector" in the official W3 specification)
can be used to match a set of elements by their local name or namespace. The
selector `foo` is used to match all elements with the local name being set to
`foo`.

Example XML:

    <root>
        <foo />
        <bar />
    </root>

CSS:

    root foo

This would return a set with only the `<foo>` element.

This selector can be used in combination with the
[Universal Selector][universal-selector]. This allows one to select elements
using both a given local name and namespace. The syntax for this is as
following:

    ns-prefix|local-name

Here the pipe (`|`) character separates the namespace prefix and the local name.
Both can either be an identifier or a wildcard. For example, the selector
`rb|foo` matches all elements with local name `foo` and namespace prefix `rb`.

The namespace prefix MAY be left out producing the selector `|local-name`. In
this case the selector only matches elements _without_ a namespace prefix.

If a namespace prefix is given and it's _not_ a wildcard then elements without a
namespace prefix will _not_ be matched.

The corresponding XPath expression for such a selector is
`ns-prefix:local-name`. For example, `rb|foo` in CSS is the same as `rb:foo` in
XPath.

### Syntax

The syntax for just the local name is as following:

    identifier = '*' | [a-zA-Z]+ [a-zA-Z\-_0-9]*;

The wildcard is put in place to allow a single rule to be used for both names
and wildcards.

The syntax for selecting an element including a namespace prefix is as
following:

    ns_plus_local_name = identifier* '|' identifier

This would match `|foo`, `*|foo` and `foo|bar`. In order to match `foo` the
regular `identifier` rule declared above can be used.

## Class Selector

Class selectors can be used to select a set of elements based on the values set
in the `class` attribute. Class selectors start with a period (`.`) followed by
an identifier. Multiple class selectors can be chained together, matching only
elements that have all the specified classes set.

As an example, `.foo` can be used to select all elements that have "foo" set in
the `class` attribute, either as the sole or one of many values. In turn,
`.foo.bar` matches elements that have both "foo" and "bar" set as the class.

Example XML:

    <root>
        <a class="first" />
        <b class="second" />
    </root>

Using the CSS selector `.first` would return a set containing only the `<a>`
element. Using `.first.second` would return a set containing both the `<a>` and
`<b>` nodes.

### Syntax

    identifier = '*' | [a-zA-Z]+ [a-zA-Z\-_0-9]*;

    # .foo, .foo.bar, .foo.bar.baz, etc
    class = ('.' identifier)+;

## ID Selector

The ID selector can be used to match elements where the value of the `id`
attribute matches whatever is specified in the selector. ID selectors start with
a hash sign (`#`) followed by an identifier.

While technically multiple ID selectors _can_ be chained together, HTML only
allows elements to have a single ID. As a result doing so is fairly useless.
Unlike classes IDs are globally unique, no two elements can have the same ID.

Example XML:

    <root>
        <a id="first" />
        <b id="second" />
    </root>

Using the CSS selector `#first` would return a set containing only the `<a>`
node.

### Syntax

    identifier = '*' | [a-zA-Z]+ [a-zA-Z\-_0-9]*;

    # .foo, .foo.bar, .foo.bar.baz, etc
    class = ('#' identifier)+;

## Attribute Selector

W3 chapter: <http://www.w3.org/TR/css3-selectors/#attribute-selectors>

Attribute selectors can be used to further narrow down a set of elements based
on their attribute list. In XPath these selectors are known as "predicates". For
example, the selector `foo[bar]` matches all `foo` elements that have a `bar`
attribute, regardless of the value of said attribute.

Example XML:

    <root>
        <foo number="1" />
        <bar />
    </root>

CSS:

    root foo[number]

This would return a set containing only the `<foo>` element since the `<bar>`
element has no attributes.

For the CSS expression `foo[number]` the corresponding XPath expression is the
following:

    foo[@number]

When specifying an attribute you MAY include an operator and a value to match.
In this case you MUST include an attribute value surrounded by either single or
double quotes (but not a combination of the two).

There are 6 operators available:

* `=`: equals operator
* `~=`: whitespace-in operator
* `^=`: starts-with operator
* `$=`: ends-with operator
* `*=`: contains operator
* `|=`: hyphen-starts-with operator

### Equals Operator

The equals operator matches an element if a given attribute value equals the
value specified. For example, `foo[number="1"]` matches all `foo` elements that
have a `number` attribute who's value is _exactly_ "1".

Example XML:

    <root>
        <foo number="1" />
        <foo number="2" />
    </root>

CSS:

    root foo[number="1"]

This would return a set containing only the first `<foo>` element.

The corresponding XPath expression is quite similar. For `foo[number="1"]` this
would be:

    foo[@number="1"]

### Whitespace-in Operator

This operator matches an element if the given attribute value consists out of
space separated values of which one is exactly the given value. For example,
`foo[numbers~="1"]` matches all `foo` elements that have the value `"1"` in the
`numbers` attribute.

Example XML:

    <root>
        <foo numbers="1 2 3" />
        <foo numbers="4 bar 6" />
    </root>

CSS:

    root foo[numbers~="1"]

This would return a set containing only the first `foo` element. On the other
hand, if one were to use the expression `root foo[numbers~="bar"]` instead then
only the second `<foo>` element would be matched.

The corresponding XPath expression is quite complex, `foo[numbers~="1"]` is
translated into the following XPath expression:

    foo[contains(concat(" ", @numbers, " "), concat(" ", "1", " "))]

The `concat` calls are used to ensure the expression doesn't match the substring
of an attrbitue value and that the expression matches elements of which the
attribute only has a single value. If `foo[contains(@numbers, ' 1 ')]` were to
be used then attributes such as `<foo numbers="1" />` would not be matched.

Software implementing this selector are free to decide how they concatenate
spaces around the value to match. Both Oga and Nokogiri use an extra call to
`concat` but the following would be perfectly valid too:

    foo[contains(concat(" ", @numbers, " "), " 1 ")]

### Starts-with Operator

This operator matches elements of which the attribute value starts _exactly_
with the given value. For example, `foo[numbers^="1"]` would match the element
`<foo numbers="1 2 3" />` but _not_ the element `<foo numbers="2 3 1" />`.

For `foo[numbers^="1"]` the corresponding XPath expression is as following:

    foo[starts-with(@numbers, "1")]

### Ends-with Operator

This operator matches elements of which the attribute value ends _exactly_ with
the given value. For example, `foo[numbers$="3"]` would match the element `<foo
numbers="1 2 3" />` but _not_ the element `<foo numbers="2 3 1" />`.

The corresponding XPath expression is quite complex due to a lack of a
`ends-with` function in XPath. Instead one has to resort to using the
`substring()` function. As such the corresponding XPath expression for
`foo[bar$="baz"]` is as following:

    foo[substring(@bar, string-length(@bar) - string-length("baz") + 1, string-length("baz")) = "baz"]

### Contains Operator

This operator matches elements of which the attribute value contains the given
value. For example, `foo[bar*="baz"]` would match both `<foo bar="bazzzz" />`
and `<foo bar="hello baz" />`.

For `foo[bar*="baz"]` the corresponding XPath expression is as following:

    foo[contains(@bar, "baz")]

### Hyphen-starts-with Operator

This operator matches elements of which the attribute value is a hyphen
separated list of values that starts _exactly_ with the given value. For
example, `foo[numbers|="1"]` matches `<foo numbers="1-2-3" />` but not
`<foo numbers="2-1-3" />`.

For `foo[numbers|="1"]` the corresponding XPath expression is as following:

    foo[@numbers = "1" or starts-with(@numbers, concat("1", "-"))]

Note that this selector will also match elements such as
`<foo numbers="1- foo bar" />`.

### Syntax

The syntax of the various attribute selectors can be described as following:

    # Strings are used for the attribute values

    dquote = '"';
    squote = "'";

    string_dquote = dquote ^dquote* dquote;
    string_squote = squote ^squote* squote;

    string = string_dquote | string_squote;

    # The `identifier` rule is the same as the one used for matching element
    # names.
    attr_test = identifier '[' space* identifier (space* '=' space* string)* space* ']';

Whitespace inside the brackets does not affect the behaviour of the selector.

## Pseudo Classes

W3 chapter: <http://www.w3.org/TR/css3-selectors/#structural-pseudos>

Pseudo classes can be used to further narrow down elements besides just their
names and attribute values. In essence they are a combination of XPath function
calls and axes. Some pseudo classes can take an argument to alter their
behaviour.

Pseudo classes are often applied to element selectors. For example:

    foo:bar

Here `:bar` would be a pseudo class applied to the `foo` element. Some pseudo
classes (e.g. the `:root` pseudo class) can also be used on their own, for
example:

    :root

### :root

The `:root` pseudo class selects an element only if it's the top-level element
in a document.

Example XML:

    <root>
        <foo />
    </root>

Using the CSS expression `root foo:root` we'd get an empty set as the `<foo>`
element is not the root element. On the other hand, `root:root` would return a
set containing only the `<root>` element.

This selector can both be applied to an element selector as well as being used
on its own.

For the selector `foo:root` the corresponding XPath expression is as following:

    foo[not(parent::*)]

For `:root` the XPath expression is:

    *[not(parent::*)]

### :nth-child(n)

The `:nth-child(n)` pseudo class can be used to select a set of elements based
on their position or an interval, skipping elements that occur in a set before
the given position or interval.

In the form `:nth-child(n)` the identifier `n` is an argument that can be used
to specify one of the following:

1. A literal node set index
2. A node interval used to match every N nodes
3. A node interval plus an initial offset

The first element in a node set for `:nth-child()` is located at position 1,
_not_ position 0 (unlike most programming languages). As a result
`:nth-child(1)` matches the _first_ element, _not_ the second. This can be
visualized as following:

               :nth-child(2)

       1     2     3     4     5     6
     +---+ +---+ +---+ +---+ +---+ +---+
     |   | | X | |   | |   | |   | |   |
     +---+ +---+ +---+ +---+ +---+ +---+

Besides using a literal index argument you can also use an interval, optionally
with an offset. This can be used to for example match every 2nd element, or
every 2nd element starting at element number 4.

The syntax of this argument is as following:

    integer  = ('+' | '-')* [0-9]+;
    interval = ('n' | '-n' | integer 'n') integer;

Here `interval` would match any of the following:

    n
    -n
    2n
    2n+5
    2n-5
    -2n+5
    -2n-5

Due to `integer` also matching the `+` and `-` it will be part of the same
token. If this is not desired the following grammar can be used instead:

    integer  = [0-9]+;
    modifier = '+' | '-';
    interval = ('n' | '-n' | modifier* integer 'n') modifier integer;

To match every 2nd element you'd use the following:

               :nth-child(2n)

       1     2     3     4     5     6
     +---+ +---+ +---+ +---+ +---+ +---+
     |   | | X | |   | | X | |   | | X |
     +---+ +---+ +---+ +---+ +---+ +---+

To match every 2nd element starting at element 1 you'd instead use this:

              :nth-child(2n+1)

       1     2     3     4     5     6
     +---+ +---+ +---+ +---+ +---+ +---+
     | X | |   | | X | |   | | X | |   |
     +---+ +---+ +---+ +---+ +---+ +---+

As mentioned the `+1` in the above example is the initial offset. This is
however _only_ the case if the second number is positive. That means that for
`:nth-child(2n-2)` the offset is _not_ `-2`. When using a negative offset the
actual offset first has to be calculated. When using an argument in the form of
`An-B` we can calculate the actual offset as following:

    offset = A - (B % A)

For example, for the selector `:nth-child(2n-2)` the formula would be:

    offset = 2 - (-2 % 2) # => 2

This would result in the selector `:nth-child(2n+2)`.

As an another example, for the selector `:nth-child(2n-5)` the formula would be:

    offset = 2 - (-5 % 2) # => 1

Which would result in the selector `:nth-child(2n+1)`

To ease the process of selecting even and uneven elements you can also use
`even` and `odd` as an argument. Using `:nth-child(even)` is the same as
`:nth-child(2n)` while using `:nth-child(odd)` in turn is the same as
`:nth-child(2n+1)`.

Using `:nth-child(n)` simply matches all elements in the set. Using
`:nth-child(-n)` doesn't match any elements, though Oga treats it the same as
`:nth-child(n)`.

Expressions such as `:nth-child(-n-5)` are invalid as both parts of the interval
(`-n` and `-5`) are a negative. However, `:nth-child(-n+5)` is
perfectly valid and would match the first 5 elements in a set:

             :nth-child(-n+5)

      1     2     3     4     5     6
    +---+ +---+ +---+ +---+ +---+ +---+
    | X | | X | | X | | X | | X | |   |
    +---+ +---+ +---+ +---+ +---+ +---+


Using `:nth-child(n+5)` would match all elements starting at element 5:

                         :nth-child(n+5)

      1     2     3     4     5     6     7     8     9    10
    +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+
    |   | |   | |   | |   | | X | | X | | X | | X | | X | | X |
    +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+

To summarize:

    :nth-child(n)    => matches all elements
    :nth-child(-n)   => matches nothing, though Oga treats it the same as "n"
    :nth-child(5)    => matches element #5
    :nth-child(2n)   => matches every 2 elements
    :nth-child(2n+2) => matches every 2 elements, starting at element 2
    :nth-child(2n-2) => matches every 2 elements, starting at element 1
    :nth-child(n+5)  => matches all elements, starting at element 5
    :nth-child(-n+5) => matches the first 5 elements
    :nth-child(even) => matches every 2nd element, starting at element 2
    :nth-child(odd)  => matches every 2nd element, starting at element 1

The corresponding XPath expressions are quite complex and differ based on the
interval argument used. For the various forms the corresponding XPath
expressions are as following:

    :nth-child(n)    => *[((count(preceding-sibling::*) + 1) mod 1) = 0]
    :nth-child(-n)   => *[((count(preceding-sibling::*) + 1) mod 1) = 0]
    :nth-child(5)    => *[count(preceding-sibling::*) = 4]
    :nth-child(2n)   => *[((count(preceding-sibling::*) + 1) mod 2) = 0]
    :nth-child(2n+2) => *[(count(preceding-sibling::*) + 1) >= 2 and (((count(preceding-sibling::*) + 1) - 2) mod 2) = 0]
    :nth-child(2n-6) => *[(count(preceding-sibling::*) + 1) >= 2 and (((count(preceding-sibling::*) + 1) - 2) mod 2) = 0]
    :nth-child(n+5)  => *[(count(preceding-sibling::*) + 1) >= 5 and (((count(preceding-sibling::*) + 1) - 5) mod 1) = 0]
    :nth-child(-n+6) => *[((count(preceding-sibling::*) + 1) <= 6) and (((count(preceding-sibling::*) + 1) - 6) mod 1) = 0]
    :nth-child(even) => *[((count(preceding-sibling::*) + 1) mod 2) = 0]
    :nth-child(odd)  => *[(count(preceding-sibling::*) + 1) >= 1 and (((count(preceding-sibling::*) + 1) - 1) mod 2) = 0]

### :nth-last-child(n)

The `:nth-last-child(n)` pseudo class can be used to select a set of elements
based on their position or an interval, skipping elements that occur in a set
after the given position or interval.

The arguments that can be used by this selector are the same as those mentioned
in [:nth-child(n)][nth-childn].

Because this selectors matches in reverse (compared to
[:nth-child(n)][nth-childn]) using an index such as "1" will match the _last_
element in a set, not the first one:

               :nth-last-child(1)

       1     2     3     4     5     6
     +---+ +---+ +---+ +---+ +---+ +---+
     |   | |   | |   | |   | |   | | X | <- matching direction
     +---+ +---+ +---+ +---+ +---+ +---+

When using an interval (with or without an offset) the nodes are also matched in
reverse order. However, matched nodes should be returned in the order they
appear in in the document.

For example, the selector `:nth-last-child(2n)` would match as following:

               :nth-last-child(2n)

       1     2     3     4     5     6
     +---+ +---+ +---+ +---+ +---+ +---+
     | X | |   | | X | |   | | X | |   | <- matching direction
     +---+ +---+ +---+ +---+ +---+ +---+

The resulting set however would contain the nodes in the order `[1, 3, 5]`
instead of `[5, 3, 1]`.

When using an interval with an initial offset the offset is also applied in
reverse order. For example, the selector `:nth-last-child(2n)` would match as
following:

               :nth-last-child(2n+1)

       1     2     3     4     5     6
     +---+ +---+ +---+ +---+ +---+ +---+
     |   | | X | |   | | X | |   | | X | <- matching direction
     +---+ +---+ +---+ +---+ +---+ +---+

The corresponding XPath expressions are similar to those used for
[:nth-child(n)][nth-childn]:

    :nth-last-child(n)    => *[count(following-sibling::*) = -1]
    :nth-last-child(-n)   => *[count(following-sibling::*) = -1]
    :nth-last-child(5)    => *[count(following-sibling::*) = 4]
    :nth-last-child(2n)   => *[((count(following-sibling::*) + 1) mod 2) = 0]
    :nth-last-child(2n+2) => *[((count(following-sibling::*) + 1) >= 2) and ((((count(following-sibling::*) + 1) - 2) mod 2) = 0)]
    :nth-last-child(2n-6) => *[((count(following-sibling::*) + 1) >= 2) and ((((count(following-sibling::*) + 1) - 2) mod 2) = 0)]
    :nth-last-child(n+5)  => *[((count(following-sibling::*) + 1) >= 5) and ((((count(following-sibling::*) + 1) - 5) mod 1) = 0)]
    :nth-last-child(-n+6) => *[((count(following-sibling::*) + 1) <= 6) and ((((count(following-sibling::*) + 1) - 6) mod 1) = 0)]
    :nth-last-child(even) => *[((count(following-sibling::*) + 1) mod 2) = 0]
    :nth-last-child(odd)  => *[((count(following-sibling::*) + 1) >= 1) and ((((count(following-sibling::*) + 1) - 1) mod 2) = 0)]

### :nth-of-type(n)

The `:nth-of-type(n)` pseudo class can be used to select a set of elements that
has a set of preceding siblings with the same name. The arguments that can be
used by this selector are the same as those mentioned in
[:nth-child(n)][nth-childn].

The matching order of this selector is the same as [:nth-child(n)][nth-childn].

Example XML:

    <root>
        <foo />
        <foo />
        <foo />
        <foo />
        <bar />
    </root>

Using the CSS expression `root foo:nth-of-type(even)` would return a set
containing the 2nd and 4th `<foo>` nodes.

The corresponding XPath expressions for the various forms of this pseudo class
are as following:

    :nth-of-type(n)    => *[position() = n]
    :nth-of-type(-n)   => *[position() = -n]
    :nth-of-type(5)    => *[position() = 5]
    :nth-of-type(2n)   => *[(position() mod 2) = 0]
    :nth-of-type(2n+2) => *[(position() >= 2) and (((position() - 2) mod 2) = 0)]
    :nth-of-type(2n-6) => *[(position() >= 2) and (((position() - 2) mod 2) = 0)]
    :nth-of-type(n+5)  => *[(position() >= 5) and (((position() - 5) mod 1) = 0)]
    :nth-of-type(-n+6) => *[(position() <= 6) and (((position() - 6) mod 1) = 0)]
    :nth-of-type(even) => *[(position() mod 2) = 0]
    :nth-of-type(odd)  => *[(position() >= 1) and (((position() - 1) mod 2) = 0)]

### :nth-last-of-type(n)

The `:nth-last-of-type(n)` pseudo class behaves the same as
[:nth-of-type(n)][nth-last-of-typen] excepts it matches nodes in reverse order
similar to [:nth-last-child(n)][nth-last-childn].  To clarify, this means
matching occurs as following:


               :nth-last-of-type(1)

       1     2     3     4     5     6
     +---+ +---+ +---+ +---+ +---+ +---+
     |   | |   | |   | |   | |   | | X | <- matching direction
     +---+ +---+ +---+ +---+ +---+ +---+

Example XML:

    <root>
        <foo />
        <foo />
        <foo />
        <foo />
        <bar />
    </root>

Using the CSS expression `root foo:nth-of-type(even)` would return a set
containing the 1st and 3rd `<foo>` nodes.

The corresponding XPath expressions for the various forms of this pseudo class
are as following:

    :nth-last-of-type(n)    => *[position() = last() - -1]
    :nth-last-of-type(-n)   => *[position() = last() - -1]
    :nth-last-of-type(5)    => *[position() = last() - 4]
    :nth-last-of-type(2n)   => *[((last() - position()+1) mod 2) = 0]
    :nth-last-of-type(2n+2) => *[((last() - position()+1) >= 2) and ((((last() - position() + 1) - 2) mod 2) = 0)]
    :nth-last-of-type(2n-6) => *[((last() - position()+1) >= 2) and ((((last() - position() + 1) - 2) mod 2) = 0)]
    :nth-last-of-type(n+5)  => *[((last() - position()+1) >= 5) and ((((last() - position() + 1) - 5) mod 1) = 0)]
    :nth-last-of-type(-n+6) => *[((last() - position()+1) <= 6) and ((((last() - position() + 1) - 6) mod 1) = 0)]
    :nth-last-of-type(even) => *[((last() - position()+1) mod 2) = 0]
    :nth-last-of-type(odd)  => *[((last() - position()+1) >= 1) and ((((last() - position() + 1) - 1) mod 2) = 0)]

### :first-child

The `:first-child` pseudo class can be used to match a node that is the first
child node of another node (= a node without any preceding nodes).

Example XML:

    <root>
        <foo />
        <bar />
    </root>

Using the CSS selector `root :first-child` would return a set containing only
the `<foo>` node.

The corresponding XPath expression for this pseudo class is as following:

    :first-child => *[count(preceding-sibling::*) = 0]

### :last-child

The `:last-child` pseudo class can be used to match a node that is the last
child node of another node (= a node without any following nodes).

Example XML:

    <root>
        <foo />
        <bar />
    </root>

Using the CSS selector `root :last-child` would return a set containing only
the `<bar>` node.

The corresponding XPath expression for this pseudo class is as following:

    :last-child => *[count(following-sibling::*) = 0]

### :first-of-type

The `:first-of-type` pseudo class matches elements that are the first sibling of
its type in the list of elements of its parent element. This selector is the
same as [:nth-of-type(1)][nth-of-typen].

Example XML:

    <root>
      <a id="1" />
      <a id="2">
        <a id="3" />
        <a id="4" />
      </a>
    </root>

Using the CSS selector `root a:first-of-type` would return a node set containing
nodes `<a id="1">` and `<a id="3">` as both nodes are the first siblings of
their type.

The corresponding XPath for this pseudo class is as following:

    a:first-of-type => a[count(preceding-sibling::a) = 0]

An alternative way is to use the following XPath:

    a:first-of-type => //a[position() = 1]

This however relies on the less efficient `descendant-or-self::node()` selector.
For querying larger documents it's recommended to use the first form instead.

### :last-of-type

The `:last-of-type` pseudo class can be used to match elements that are the last
sibling of its type in the list of elements of its parent. This selector is the
same as [:nth-last-of-type(1)][nth-last-of-typen].

Example XML:

    <root>
      <a id="1" />
      <a id="2">
        <a id="3" />
        <a id="4" />
      </a>
    </root>

Using the CSS selector `root a:last-of-type` would return a set containing nodes
`<a id="2">` and `<a id="4">` as both nodes are the last siblings of their type.

The corresponding XPath for this pseudo class is as following:

    a:last-of-type => a[count(following-sibling::a) = 0]

Similar to [:first-of-type][first-of-typen] this XPath can alternatively be
written as following:

    a:last-of-type => //a[position() = last()]

### :only-child

The `:only-child` pseudo class can be used to match elements that are the only
child element of its parent.

Example XML:

    <root>
      <a id="1" />
      <a id="2">
        <a id="3" />
      </a>
    </root>

Using the CSS selector `root a:only-child` would return a set containing only
the `<a id="3">` node.

The corresponding XPath for this pseudo class is as following:

    a:only-child => a[count(preceding-sibling::*) = 0 and count(following-sibling::*) = 0]

### :only-of-type

The `:only-of-type` pseudo class can be used to match elements that are the only
child elements of its type of its parent.

Example XML:

    <root>
      <a id="1" />
      <a id="2">
        <a id="3" />
        <b id="4" />
      </a>
    </root>

Using the CSS selector `root a:only-of-type` would return a set containing
only the `<a id="3">` node due to it being the only `<a>` node in the list of
elements of its parent.

The corresponding XPath for this pseudo class is as following:

    a:only-child => a[count(preceding-sibling::a) = 0 and count(following-sibling::a) = 0]

### :empty

The `:empty` pseudo class can be used to match elements that have no child nodes
at all.

Example XML:

    <root>
        <a />
        <b>10</b>
    </root>

Using the CSS selector `root :empty` would return a set containing only the
`<a>` node.

### Syntax

The syntax of the various pseudo classes is as following:

    integer = ('+' | '-')* [0-9]+;

    odd  = 'odd';
    even = 'even';
    nth  = 'n';

    pseudo_arg_interval = '-'* integer* nth;
    pseudo_arg_offset   = ('+' | '-')* integer;

    pseudo_arg = odd
      | even
      | '-'* nth
      | integer
      | pseudo_arg_interval
      | pseudo_arg_interval pseudo_arg_offset;

    # The `identifier` rule is the same as the one used for element names.
    pseudo = ':' identifier ('(' space* pseudo_arg space* ')')*;

[w3spec]: http://www.w3.org/TR/css3-selectors/
[rfc-2119]: https://www.ietf.org/rfc/rfc2119.txt
[kramdown]: http://kramdown.gettalong.org/
[universal-selector]: #universal-selector
[ragel]: http://www.colm.net/open-source/ragel/
[nth-childn]: #nth-childn
[nth-last-childn]: #nth-last-childn
[nth-last-of-typen]: #nth-last-of-typen
[nth-of-typen]: #nth-of-type
[nth-last-of-typen]: #nth-last-of-typen
[first-of-typen]: #first-of-typen
