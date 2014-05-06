#include "xml.h"

VALUE oga_mXML;

void Init_liboga_xml()
{
    oga_mXML = rb_define_module_under(oga_mOga, "XML");
}
