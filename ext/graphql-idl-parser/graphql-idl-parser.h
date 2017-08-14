#ifndef GRAPHQLIDLPARSER_H
#define GRAPHQLIDLPARSER_H

#ifndef __MSXML_LIBRARY_DEFINED__
#define __MSXML_LIBRARY_DEFINED__
#endif

#define CSTR2SYM(s) (ID2SYM(rb_intern((s))))

#include "ruby.h"
#include <ruby/encoding.h>
#include "gql-idl-parser.h"

#include "graphql-idl-parser.h"

static VALUE rb_mGraphQL;
static VALUE rb_cGraphQLIDLParser;

VALUE convert_string(const char* c_string);
VALUE convert_type_info(struct FieldType c_field_type);
VALUE convert_array_of_strings(struct array_of_strings c_array_of_strings);
VALUE convert_array_of_arguments(struct array_of_arguments c_array_of_arguments);
VALUE convert_array_of_fields(struct array_of_fields c_array_of_fields);
VALUE convert_array_of_values(struct array_of_values c_array_of_values);
VALUE convert_array_of_directives(struct array_of_directives c_array_of_directives);

#endif
