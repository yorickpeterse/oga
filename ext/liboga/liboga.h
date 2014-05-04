#ifndef LIBOGA_H
#define LIBOGA_H

#include <ruby.h>
#include <ruby/encoding.h>
#include <string.h>
#include <malloc.h>
#include <stdio.h>

extern VALUE oga_mOga;

#include "xml.h"
#include "lexer.h"

void Init_liboga();

#endif
