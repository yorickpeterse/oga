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

VALUE oga_cLexer;

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
 * Lexes the input String specified in the instance variable `@data`. Lexed
 * values have the same encoding as the input value. This instance variable
 * is set in the Ruby layer of the lexer.
 *
 * The Ragel loop dispatches method calls back to Ruby land to make it easier
 * to implement complex actions without having to fiddle around with C. This
 * introduces a small performance overhead compared to a pure C implementation.
 * However, this is worth the overhead due to it being much easier to maintain.
 */
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

    /*
    Fixed stack size is enough since the lexer doesn't use that many nested
    fcalls.
    */
    int stack[8];

    %% write init;
    %% write exec;

    return Qnil;
}

%%{
    include base_lexer "base_lexer.rl";
}%%

void Init_liboga_xml_lexer()
{
    oga_cLexer = rb_define_class_under(oga_mXML, "Lexer", rb_cObject);

    rb_define_method(oga_cLexer, "advance_native", oga_xml_lexer_advance, 0);
}
