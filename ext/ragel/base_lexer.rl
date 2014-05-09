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

    newline    = '\n' | '\r\n';
    whitespace = [ \t];
    identifier = [a-zA-Z0-9\-_:]+;

    # Strings
    #
    # Strings in HTML can either be single or double quoted. If a string
    # starts with one of these quotes it must be closed with the same type
    # of quote.
    dquote = '"';
    squote = "'";

    # Machine for processing double quoted strings.
    string_dquote := |*
        ^dquote+ => {
            callback("on_string", data, encoding, ts, te);
        };

        dquote => { fret; };
    *|;

    # Machine for processing single quoted strings.
    string_squote := |*
        ^squote+ => {
            callback("on_string", data, encoding, ts, te);
        };

        squote => { fret; };
    *|;

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
        fcall doctype;
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
        dquote => { fcall string_dquote; };
        squote => { fcall string_squote; };

        # Whitespace inside doctypes is ignored since there's no point in
        # including it.
        whitespace;

        identifier => {
            callback("on_doctype_name", data, encoding, ts, te);
        };

        '>' => {
            callback_simple("on_doctype_end");
            fret;
        };
    *|;

    # CDATA
    #
    # http://www.w3.org/TR/html-markup/syntax.html#cdata-sections
    #
    # CDATA tags are broken up into 3 parts: the start, the content and the
    # end tag.
    #
    # In HTML CDATA tags have no meaning/are not supported. Oga does
    # support them but treats their contents as plain text.
    #
    cdata_start = '<![CDATA[';
    cdata_end   = ']]>';

    action start_cdata {
        callback_simple("on_cdata_start");
        fcall cdata;
    }

    # Machine that for processing the contents of CDATA tags. Everything
    # inside a CDATA tag is treated as plain text.
    cdata := |*
        any* cdata_end => {
            callback("on_text", data, encoding, ts, te - 3);
            callback_simple("on_cdata_end");
            fret;
        };
    *|;

    # Comments
    #
    # http://www.w3.org/TR/html-markup/syntax.html#comments
    #
    # Comments are lexed into 3 parts: the start tag, the content and the
    # end tag.
    #
    # Unlike the W3 specification these rules *do* allow character
    # sequences such as `--` and `->`. Putting extra checks in for these
    # sequences would actually make the rules/actions more complex.
    #
    comment_start = '<!--';
    comment_end   = '-->';

    action start_comment {
        callback_simple("on_comment_start");
        fcall comment;
    }

    # Machine used for processing the contents of a comment. Everything
    # inside a comment is treated as plain text (similar to CDATA tags).
    comment := |*
        any* comment_end => {
            callback("on_text", data, encoding, ts, te - 3);
            callback_simple("on_comment_end");
            fret;
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
        fcall xml_decl;
    }

    # Machine that processes the contents of an XML declaration tag.
    xml_decl := |*
        xml_decl_end => {
            callback_simple("on_xml_decl_end");
            fret;
        };

        # Attributes and their values (e.g. version="1.0").
        identifier => {
            callback("on_attribute", data, encoding, ts, te);
        };

        dquote => { fcall string_dquote; };
        squote => { fcall string_squote; };

        any;
    *|;

    # Elements
    #
    # http://www.w3.org/TR/html-markup/syntax.html#syntax-elements
    #

    # Action that creates the tokens for the opening tag, name and
    # namespace (if any). Remaining work is delegated to a dedicated
    # machine.
    action start_element {
        callback("on_element_start", data, encoding, ts + 1, te);

        fcall element_head;
    }

    element_start = '<' identifier;

    # Machine used for processing the characters inside a element head. An
    # element head is everything between `<NAME` (where NAME is the element
    # name) and `>`.
    #
    # For example, in `<p foo="bar">` the element head is ` foo="bar"`.
    #
    element_head := |*
        whitespace | '=';

        newline => {
            callback_simple("on_newline");
        };

        # Attribute names.
        identifier => {
            callback("on_attribute", data, encoding, ts, te);
        };

        # Attribute values.
        dquote => { fcall string_dquote; };
        squote => { fcall string_squote; };

        # The closing character of the open tag.
        ('>' | '/') => {
            fhold;
            fret;
        };
    *|;

    main := |*
        element_start  => start_element;
        doctype_start  => start_doctype;
        cdata_start    => start_cdata;
        comment_start  => start_comment;
        xml_decl_start => start_xml_decl;

        # Enter the body of the tag. If HTML mode is enabled and the current
        # element is a void element we'll close it and bail out.
        '>' => {
            callback_simple("on_element_open_end");
        };

        # Regular closing tags.
        '</' identifier '>' => {
            callback_simple("on_element_end");
        };

        # Self closing elements that are not handled by the HTML mode.
        '/>' => {
            callback_simple("on_element_end");
        };

        # Note that this rule should be declared at the very bottom as it
        # will otherwise take precedence over the other rules.
        ^('<' | '>')+ => {
            callback("on_text", data, encoding, ts, te);
        };
    *|;
}%%
