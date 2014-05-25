#include "lexer.h"

/*
The following two macros allow the Ragel grammar to use generic function calls
without relying on the setup of the C or Java lexer. Using these macros we can
also pass along `self` to the callback functions without having to hard-code
this in to the Ragel grammar.

In the C lexer we don't need the `data` variable (since this is pulled in based
on `ts` and `te`) so the macro ignores this argument.
*/

#define callback(name, data, encoding, start, stop) \
    liboga_xml_lexer_callback(self, name, encoding, start, stop);

#define callback_simple(name) \
    liboga_xml_lexer_callback_simple(self, name);

#define oga_ivar_get(owner, name) \
    rb_ivar_get(owner, rb_intern(name))

#define oga_ivar_set(owner, name, value) \
    rb_ivar_set(owner, rb_intern(name), value)

%%machine c_lexer;

/**
 * Calls a method defined in the Ruby side of the lexer. The String value is
 * created based on the values of `ts` and `te` and uses the encoding specified
 * in `encoding`.
 *
 * @example
 *  rb_encoding *encoding = rb_enc_get(...);
 *  liboga_xml_lexer_callback(self, "on_string", encoding, ts, te);
 */
void liboga_xml_lexer_callback(
    VALUE self,
    const char *name,
    rb_encoding *encoding,
    const char *ts,
    const char *te
)
{
    VALUE value  = rb_enc_str_new(ts, te - ts, encoding);
    VALUE method = rb_intern(name);

    rb_funcall(self, method, 1, value);
}

/**
 * Calls a method defined in the Ruby side of the lexer without passing it any
 * arguments.
 *
 * @example
 *  liboga_xml_lexer_callback_simple(self, "on_cdata_start");
 */
void liboga_xml_lexer_callback_simple(VALUE self, const char *name)
{
    VALUE method = rb_intern(name);

    rb_funcall(self, method, 0);
}

%% write data;

/**
 * Lexes the String specifies as the method argument. Token values have the
 * same encoding as the input value.
 *
 * This method keeps track of an internal state using the instance variables
 * `@act` and `@cs`.
 */
VALUE oga_xml_lexer_advance(VALUE self, VALUE data_block)
{
    /* Make sure that all data passed back to Ruby has the proper encoding. */
    rb_encoding *encoding = rb_enc_get(data_block);

    char *data_str_val = StringValuePtr(data_block);

    const char *p   = data_str_val;
    const char *pe  = data_str_val + strlen(data_str_val);
    const char *eof = pe;
    const char *ts  = 0;
    const char *te  = 0;

    int act = NUM2INT(oga_ivar_get(self, "@act"));
    int cs  = NUM2INT(oga_ivar_get(self, "@cs"));

    %% write exec;

    oga_ivar_set(self, "@act", INT2NUM(act));
    oga_ivar_set(self, "@cs", INT2NUM(cs));

    return Qnil;
}

/**
 * Resets the internal state of the lexer.
 */
VALUE oga_xml_lexer_reset(VALUE self)
{
    oga_ivar_set(self, "@act", INT2NUM(0));
    oga_ivar_set(self, "@cs", INT2NUM(c_lexer_start));

    return Qnil;
}

%%{
    include base_lexer "base_lexer.rl";
}%%

void Init_liboga_xml_lexer()
{
    VALUE mOga   = rb_const_get(rb_cObject, rb_intern("Oga"));
    VALUE mXML   = rb_const_get(mOga, rb_intern("XML"));
    VALUE cLexer = rb_define_class_under(mXML, "Lexer", rb_cObject);

    rb_define_method(cLexer, "advance_native", oga_xml_lexer_advance, 1);
    rb_define_method(cLexer, "reset_native", oga_xml_lexer_reset, 0);
}
