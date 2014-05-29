%%machine base_lexer;

%%{
    ##
    # Base grammar for the XML lexer.
    #
    # This grammar is shared between the C and Java extensions. As a result of
    # this you should **not** include language specific code in Ragel
    # actions/callbacks.
    #
    # To call back in to Ruby you can use one of the following two functions:
    #
    # * callback
    # * callback_simple
    #
    # The first function takes 5 arguments:
    #
    # * The name of the Ruby method to call.
    # * The input data.
    # * The encoding of the input data.
    # * The start of the current buffer.
    # * The end of the current buffer.
    #
    # The function callback_simple only takes one argument: the name of the
    # method to call. This function should be used for callbacks that don't
    # require any values.
    #
    # When you call a method in Ruby make sure that said method is defined as
    # an instance method in the `Oga::XML::Lexer` class.
    #
    # ## Machine Transitions
    #
    # To transition from one machine to another always use `fnext` instead of
    # `fcall` and `fret`. This removes the need for the code to keep track of a
    # stack.
    #

    newline    = '\n' | '\r\n';
    whitespace = [ \t];
    identifier = [a-zA-Z0-9\-_]+;
    attribute  = [a-zA-Z0-9\-_:]+;

    # Comments
    #
    # http://www.w3.org/TR/html-markup/syntax.html#comments
    #
    # Unlike the W3 specification these rules *do* allow character sequences
    # such as `--` and `->`. Putting extra checks in for these sequences would
    # actually make the rules/actions more complex.
    #
    comment = '<!--' any* '-->';

    # CDATA
    #
    # http://www.w3.org/TR/html-markup/syntax.html#cdata-sections
    #
    # In HTML CDATA tags have no meaning/are not supported. Oga does
    # support them but treats their contents as plain text.
    #
    cdata = '<![CDATA[' any* ']]>';

    # Strings
    #
    # Strings in HTML can either be single or double quoted. If a string
    # starts with one of these quotes it must be closed with the same type
    # of quote.
    #
    dquote = '"';
    squote = "'";

    string_dquote = (dquote ^dquote+ dquote);
    string_squote = (squote ^squote+ squote);

    string = string_dquote | string_squote;

    action emit_string {
        callback("on_string", data, encoding, ts + 1, te - 1);
    }

    # DOCTYPES
    #
    # http://www.w3.org/TR/html-markup/syntax.html#doctype-syntax
    #
    # These rules support the 3 flavours of doctypes:
    #
    # 1. Normal doctypes, as introduced in the HTML5 specification.
    # 2. Deprecated doctypes, the more verbose ones used prior to HTML5.
    # 3. Legacy doctypes
    #
    doctype_start = '<!DOCTYPE'i whitespace+;

    action start_doctype {
        callback_simple("on_doctype_start");
        fnext doctype;
    }

    # Machine for processing doctypes. Doctype values such as the public
    # and system IDs are treated as T_STRING tokens.
    doctype := |*
        'PUBLIC' | 'SYSTEM' => {
            callback("on_doctype_type", data, encoding, ts, te);
        };

        # Consumes everything between the [ and ]. Due to the use of :> the ]
        # is not consumed by any+.
        '[' any+ :> ']' => {
            callback("on_doctype_inline", data, encoding, ts + 1, te - 1);
        };

        # Lex the public/system IDs as regular strings.
        string => emit_string;

        # Whitespace inside doctypes is ignored since there's no point in
        # including it.
        whitespace;

        identifier => {
            callback("on_doctype_name", data, encoding, ts, te);
        };

        '>' => {
            callback_simple("on_doctype_end");
            fnext main;
        };
    *|;

    # XML declaration tags
    #
    # http://www.w3.org/TR/REC-xml/#sec-prolog-dtd
    #
    xml_decl_start = '<?xml';
    xml_decl_end   = '?>';

    action start_xml_decl {
        callback_simple("on_xml_decl_start");
        fnext xml_decl;
    }

    # Machine that processes the contents of an XML declaration tag.
    xml_decl := |*
        xml_decl_end => {
            callback_simple("on_xml_decl_end");
            fnext main;
        };

        # Attributes and their values (e.g. version="1.0").
        attribute => {
            callback("on_attribute", data, encoding, ts, te);
        };

        string => emit_string;

        any;
    *|;

    # Elements
    #
    # http://www.w3.org/TR/html-markup/syntax.html#syntax-elements
    #
    # Lexing of elements is broken up into different machines that handle the
    # name/namespace, contents of the open tag and the body of an element. The
    # body of an element is lexed using the `main` machine.
    #
    action start_element {
        callback_simple("on_element_start");
        fnext element_name;
    }

    # Machine used for lexing the name/namespace of an element.
    element_name := |*
        identifier ':' => {
            callback("on_element_ns", data, encoding, ts, te - 1);
        };

        identifier => {
            callback("on_element_name", data, encoding, ts, te);
            fnext element_head;
        };
    *|;

    # Machine used for processing the contents of an element's starting tag.
    # This includes the name, namespace and attributes.
    element_head := |*
        whitespace | '=';

        newline => {
            callback_simple("advance_line");
        };

        # Attribute names.
        attribute => {
            callback("on_attribute", data, encoding, ts, te);
        };

        # Attribute values.
        string => emit_string;

        # We're done with the open tag of the element.
        '>' => {
            callback_simple("on_element_open_end");
            fnext main;
        };

        # Self closing tags.
        '/>' => {
            callback_simple("on_element_end");
            fnext main;
        };
    *|;

    # The main machine aka the entry point of Ragel.
    main := |*
        doctype_start  => start_doctype;
        xml_decl_start => start_xml_decl;

        comment => {
            callback("on_comment", data, encoding, ts + 4, te - 3);
        };

        cdata => {
            callback("on_cdata", data, encoding, ts + 9, te - 3);
        };

        # The start of an element.
        '<' => start_element;

        # Regular closing tags.
        '</' identifier '>' => {
            callback_simple("on_element_end");
        };

        # Treat everything else, except for "<", as regular text. The "<" sign
        # is used for tags so we can't emit text nodes for these characters.
        ^'<'+ => {
            callback("on_text", data, encoding, ts, te);
        };
    *|;
}%%
