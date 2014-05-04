#include "liboga.h"

VALUE oga_mOga;

void Init_liboga()
{
    oga_mOga = rb_define_module("Oga");

    Init_liboga_xml();
    Init_liboga_xml_lexer();
}
