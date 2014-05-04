#include "lexer.h"

VALUE oga_cLexer;

%%machine lexer;

void oga_xml_lexer_callback(
  VALUE self,
  const char *name,
  rb_encoding *encoding,
  const char *ts,
  const char *te
)
{
  int length   = te - ts;
  VALUE value  = rb_enc_str_new_cstr(strndup(ts, length), encoding);
  VALUE method = rb_intern(name);

  rb_funcall(self, method, 1, value);
}

void oga_xml_lexer_callback_simple(VALUE self, const char *name)
{
  VALUE method = rb_intern(name);

  rb_funcall(self, method, 0);
}

%% write data;

VALUE oga_xml_lexer_advance(VALUE self)
{
  /* Pull the data in from Ruby land. */
  VALUE data_ivar = rb_ivar_get(self, rb_intern("@data"));

  /* Make sure that all data passed back to Ruby has the proper encoding. */
  rb_encoding *encoding = rb_enc_get(data_ivar);

  char *data_str_val = StringValuePtr(data_ivar);

  const char *p   = data_str_val;
  const char *pe  = data_str_val + strlen(data_str_val);
  const char *eof = pe;
  const char *ts, *te;

  int act = 0;
  int cs  = 0;
  int top = 0;
  int stack[8];

  %% write init;
  %% write exec;

  return Qnil;
}

%%{
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
        oga_xml_lexer_callback(self, "on_string", encoding, ts, te);
      };

      dquote => { fret; };
    *|;

    # Machine for processing single quoted strings.
    string_squote := |*
      ^squote+ => {
        oga_xml_lexer_callback(self, "on_string", encoding, ts, te);
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
      oga_xml_lexer_callback_simple(self, "on_start_doctype");
      fcall doctype;
    }

    # Machine for processing doctypes. Doctype values such as the public
    # and system IDs are treated as T_STRING tokens.
    doctype := |*
      'PUBLIC' | 'SYSTEM' => {
        oga_xml_lexer_callback(self, "on_doctype_type", encoding, ts, te);
      };

      # Lex the public/system IDs as regular strings.
      dquote => { fcall string_dquote; };
      squote => { fcall string_squote; };

      # Whitespace inside doctypes is ignored since there's no point in
      # including it.
      whitespace;

      identifier => {
        oga_xml_lexer_callback(self, "on_doctype_name", encoding, ts, te);
      };

      '>' => {
        oga_xml_lexer_callback_simple(self, "on_doctype_end");
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
      oga_xml_lexer_callback_simple(self, "on_cdata_start");
      fcall cdata;
    }

    # Machine that for processing the contents of CDATA tags. Everything
    # inside a CDATA tag is treated as plain text.
    cdata := |*
      any* cdata_end => {
        oga_xml_lexer_callback(self, "on_text", encoding, ts, te - 3);
        oga_xml_lexer_callback_simple(self, "on_cdata_end");
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
      oga_xml_lexer_callback_simple(self, "on_comment_start");
      fcall comment;
    }

    # Machine used for processing the contents of a comment. Everything
    # inside a comment is treated as plain text (similar to CDATA tags).
    comment := |*
      any* comment_end => {
        oga_xml_lexer_callback(self, "on_text", encoding, ts, te - 3);
        oga_xml_lexer_callback_simple(self, "on_comment_end");
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
      oga_xml_lexer_callback_simple(self, "on_xml_decl_start");
      fcall xml_decl;
    }

    # Machine that processes the contents of an XML declaration tag.
    xml_decl := |*
      xml_decl_end => {
        oga_xml_lexer_callback_simple(self, "on_xml_decl_end");
        fret;
      };

      # Attributes and their values (e.g. version="1.0").
      identifier => {
        oga_xml_lexer_callback(self, "on_attribute", encoding, ts, te);
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
      oga_xml_lexer_callback(self, "on_element_start", encoding, ts + 1, te);

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
        oga_xml_lexer_callback_simple(self, "on_newline");
      };

      # Attribute names.
      identifier => {
        oga_xml_lexer_callback(self, "on_attribute", encoding, ts, te);
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
        oga_xml_lexer_callback_simple(self, "on_element_open_end");
      };

      # Regular closing tags.
      '</' identifier '>' => {
        oga_xml_lexer_callback_simple(self, "on_element_end");
      };

      # Self closing elements that are not handled by the HTML mode.
      '/>' => {
        oga_xml_lexer_callback_simple(self, "on_element_end");
      };

      # Note that this rule should be declared at the very bottom as it
      # will otherwise take precedence over the other rules.
      ^('<' | '>')+ => {
        oga_xml_lexer_callback(self, "on_text", encoding, ts, te);
      };
    *|;
}%%

void Init_liboga_xml_lexer()
{
  oga_cLexer = rb_define_class_under(oga_mXML, "Lexer", rb_cObject);

  rb_define_method(oga_cLexer, "advance_native", oga_xml_lexer_advance, 0);
}
