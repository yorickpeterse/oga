# XML Namespaces

Oga fully supports registering XML namespaces and querying elements using these
namespaces, including alternative default namespaces.

Namespaces can be registered in two ways:

1. Namespaces defined in the document itself (e.g. `xmlns:foo="..."`)
2. By using {Oga::XML::Element#register\_namespace}

Note that manually registering namespaces does not alter the input document when
serialized back to XML. To do so you'll have to manually add the corresponding
attributes using {Oga::XML::Element#set}.

## Document Namespaces

Documents can contain two types of namespaces:

1. Named namespaces
2. Default namespaces

The first are registered as following:

    <root xmlns:foo="http://foo.com">

    </root>

Here we register a new namespace with prefix "foo" and URI "http://foo.com".

Default namespaces are registered in a similar fashion, except they come without
a prefix:

    <root xmlns="http://foo.com">

    </root>

## Manually Registered Namespaces

If you ever want to register a namespace yourself, without having to first
change the input document, you can do so as following:

    element = Oga::XML::Element.new(:name => 'root')

    element.register_namespace('foo', 'http://foo.com')

Trying to register an already existing namespace will result in `ArgumentError`
being raised.

## Listing Namespaces

To query all the namespaces available to an element you can use
{Oga::XML::Element#available\_namespaces}. This method returns a Hash
containing all {Oga::XML::Namespace} instances available to the element. The
keys are the namespace prefixes, the values the Namespace instances. Inner
namespaces overwrite outer namespaces.

Example:

    element = Oga::XML::Element.new(:name => 'root')

    element.register_namespace('foo', 'http://foo.com')

    element.available_namespaces # => {"foo" => Namespace(name: "foo", uri: "http://foo.com")}
