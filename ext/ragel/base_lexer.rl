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
    # The name of the callback to invoke should be an identifier starting with
    # "id_". The identifier should be defined in the associated C and Java code.
    # In case of C code its value should be a Symbol as a ID object, for Java
    # it should be a String. For example:
    #
    #     ID id_foo = rb_intern("foo");
    #
    # And for Java:
    #
    #     String id_foo = "foo";
    #
    # ## Machine Transitions
    #
    # To transition from one machine to another always use `fnext` instead of
    # `fcall` and `fret`. This removes the need for the code to keep track of a
    # stack.
    #

    newline = '\r\n' | '\n' | '\r';

    action count_newlines {
        if ( fc == '\n' ) lines++;
    }

    whitespace = [ \t];
    ident_char = [a-zA-Z0-9\-_];
    identifier = ident_char+;

    # Comments
    #
    # http://www.w3.org/TR/html-markup/syntax.html#comments
    #
    # Unlike the W3 specification these rules *do* allow character sequences
    # such as `--` and `->`. Putting extra checks in for these sequences would
    # actually make the rules/actions more complex.
    #

    comment_start = '<!--';
    comment_end   = '-->';
    comment       = comment_start (any* -- comment_end) comment_end;

    action start_comment {
        callback(id_on_comment, data, encoding, ts + 4, te - 3);
    }

    # CDATA
    #
    # http://www.w3.org/TR/html-markup/syntax.html#cdata-sections
    #
    # In HTML CDATA tags have no meaning/are not supported. Oga does
    # support them but treats their contents as plain text.
    #

    cdata_start = '<![CDATA[';
    cdata_end   = ']]>';
    cdata       = cdata_start (any* -- cdata_end) cdata_end;

    action start_cdata {
        callback(id_on_cdata, data, encoding, ts + 9, te - 3);
    }

    # Processing Instructions
    #
    # http://www.w3.org/TR/xpath/#section-Processing-Instruction-Nodes
    # http://en.wikipedia.org/wiki/Processing_Instruction
    #
    # These are tags meant to be used by parsers/libraries for custom behaviour.
    # One example are the tags used by PHP: <?php and ?>. Note that the XML
    # declaration tags (<?xml ?>) are not considered to be a processing
    # instruction.
    #

    proc_ins_start = '<?' identifier;
    proc_ins_end   = '?>';

    action start_proc_ins {
        callback_simple(id_on_proc_ins_start);
        callback(id_on_proc_ins_name, data, encoding, ts + 2, te);

        mark = te;

        fnext proc_ins_body;
    }

    proc_ins_body := |*
        proc_ins_end => {
            callback(id_on_text, data, encoding, mark, ts);
            callback_simple(id_on_proc_ins_end);

            mark = 0;

            fnext main;
        };

        any;
    *|;

    # Strings
    #
    # Strings in HTML can either be single or double quoted. If a string
    # starts with one of these quotes it must be closed with the same type
    # of quote.
    #
    dquote = '"';
    squote = "'";

    action emit_string {
        callback(id_on_string_body, data, encoding, ts, te);

        if ( lines > 0 )
        {
            advance_line(lines);

            lines = 0;
        }
    }

    action start_string_squote {
        callback_simple(id_on_string_squote);

        fcall string_squote;
    }

    action start_string_dquote {
        callback_simple(id_on_string_dquote);

        fcall string_dquote;
    }

    string_squote := |*
        ^squote* $count_newlines => emit_string;

        squote => {
            callback_simple(id_on_string_squote);

            fret;
        };
    *|;

    string_dquote := |*
        ^dquote* $count_newlines => emit_string;

        dquote => {
            callback_simple(id_on_string_dquote);

            fret;
        };
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
        callback_simple(id_on_doctype_start);
        fnext doctype;
    }

    # Machine for processing inline rules of a doctype.
    doctype_inline := |*
        ^']'* $count_newlines => {
            callback(id_on_doctype_inline, data, encoding, ts, te);

            if ( lines > 0 )
            {
                advance_line(lines);

                lines = 0;
            }
        };

        ']' => { fnext doctype; };
    *|;

    # Machine for processing doctypes. Doctype values such as the public
    # and system IDs are treated as T_STRING tokens.
    doctype := |*
        'PUBLIC' | 'SYSTEM' => {
            callback(id_on_doctype_type, data, encoding, ts, te);
        };

        # Starts a set of inline doctype rules.
        '[' => { fnext doctype_inline; };

        # Lex the public/system IDs as regular strings.
        squote => start_string_squote;
        dquote => start_string_dquote;

        # Whitespace inside doctypes is ignored since there's no point in
        # including it.
        whitespace;

        identifier => {
            callback(id_on_doctype_name, data, encoding, ts, te);
        };

        '>' => {
            callback_simple(id_on_doctype_end);
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
        callback_simple(id_on_xml_decl_start);
        fnext xml_decl;
    }

    # Machine that processes the contents of an XML declaration tag.
    xml_decl := |*
        xml_decl_end => {
            callback_simple(id_on_xml_decl_end);
            fnext main;
        };

        # Attributes and their values (e.g. version="1.0").
        identifier => {
            callback(id_on_attribute, data, encoding, ts, te);
        };

        squote => start_string_squote;
        dquote => start_string_dquote;

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

    element_start = '<' ident_char;
    element_end   = '</' identifier (':' identifier)* '>';

    action start_element {
        callback_simple(id_on_element_start);
        fhold;
        fnext element_name;
    }

    action close_element {
        callback_simple(id_on_element_end);
    }

    # Machine used for lexing the name/namespace of an element.
    element_name := |*
        identifier ':' => {
            callback(id_on_element_ns, data, encoding, ts, te - 1);
        };

        identifier => {
            callback(id_on_element_name, data, encoding, ts, te);
            fnext element_head;
        };
    *|;

    # Machine used for processing the contents of an element's starting tag.
    # This includes the name, namespace and attributes.
    element_head := |*
        whitespace | '=';

        newline => {
            callback_simple(id_advance_line);
        };

        # Attribute names and namespaces.
        identifier ':' => {
            callback(id_on_attribute_ns, data, encoding, ts, te - 1);
        };

        identifier => {
            callback(id_on_attribute, data, encoding, ts, te);
        };

        # Attribute values.
        squote => start_string_squote;
        dquote => start_string_dquote;

        # We're done with the open tag of the element.
        '>' => {
            callback_simple(id_on_element_open_end);

            if ( literal_html_element_p() )
            {
                fnext literal_html_element;
            }
            else
            {
                fnext main;
            }
        };

        # Self closing tags.
        '/>' => {
            callback_simple(id_on_element_end);
            fnext main;
        };
    *|;

    # Text
    #
    # http://www.w3.org/TR/xml/#syntax
    # http://www.w3.org/TR/html-markup/syntax.html#text-syntax
    #
    # Text content is everything leading up to certain special tags such as "</"
    # and "<?".

    action start_text {
        fhold;
        fnext text;
    }

    # These characters terminate a T_TEXT sequence and instruct Ragel to jump
    # back to the main machine.
    #
    # Note that this only works if each sequence is exactly 2 characters
    # long. Because of this "<!" is used instead of "<!--".

    terminate_text = '</' | '<!' | '<?' | element_start;
    allowed_text   = (any* -- terminate_text) $count_newlines;

    text := |*
        terminate_text | allowed_text => {
            callback(id_on_text, data, encoding, ts, te);

            if ( lines > 0 )
            {
                advance_line(lines);

                lines = 0;
            }

            fnext main;
        };

        # Text followed by a special tag, such as "foo<!--"
        allowed_text %{ mark = p; } terminate_text => {
            callback(id_on_text, data, encoding, ts, mark);

            p    = mark - 1;
            mark = 0;

            if ( lines > 0 )
            {
                advance_line(lines);

                lines = 0;
            }

            fnext main;
        };
    *|;

    # Certain tags in HTML can contain basically anything except for the literal
    # closing tag. Two examples are script and style tags.  As a result of this
    # we can't use the regular text machine.
    literal_html_closing_tags = '</script>' | '</style>';
    literal_html_allowed = (any* -- literal_html_closing_tags) $count_newlines;

    literal_html_element := |*
        literal_html_allowed => {
            callback(id_on_text, data, encoding, ts, te);

            if ( lines > 0 )
            {
                advance_line(lines);

                lines = 0;
            }
        };

        literal_html_allowed %{ mark = p; } literal_html_closing_tags => {
            callback(id_on_text, data, encoding, ts, mark);

            p    = mark - 1;
            mark = 0;

            if ( lines > 0 )
            {
                advance_line(lines);

                lines = 0;
            }

            fnext main;
        };
    *|;

    # The main machine aka the entry point of Ragel.
    main := |*
        doctype_start  => start_doctype;
        xml_decl_start => start_xml_decl;
        comment        => start_comment;
        cdata          => start_cdata;
        proc_ins_start => start_proc_ins;
        element_start  => start_element;
        element_end    => close_element;
        any            => start_text;
    *|;
}%%
