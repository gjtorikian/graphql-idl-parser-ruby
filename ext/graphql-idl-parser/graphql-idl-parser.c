#include "graphql-idl-parser.h"

static VALUE rb_mGraphQL;
static VALUE rb_cGraphQLIDLParser;

VALUE check_for_string(const char* string) {
  if (strncmp(string, "", 1) == 0) {
    return Qnil;
  }

  return rb_str_new2(string);
}

static VALUE GRAPHQLIDLPARSERPROCESS_process(VALUE self)
{
  VALUE rb_schema = rb_iv_get(self, "@schema");
  const char *schema = StringValueCStr(rb_schema);
  GraphQLTypes* types = NULL;
  size_t types_len = 0;
  uint8_t err;

  VALUE rb_definitions = rb_ary_new();

  err = gqlidl_parse_schema(schema, &types, &types_len);

  if (err > 0) {
    printf("Error: Return code %d", err);
    exit(err);
  }

  for (size_t i = 0; i < types_len; i++) {
    VALUE rb_hash = rb_hash_new();
    if (strcmp(types[i].typename, "scalar") == 0) {
      rb_hash_aset(rb_hash, CSTR2SYM("typename"), rb_str_new2(types[i].typename));
      rb_hash_aset(rb_hash, CSTR2SYM("name"), rb_str_new2(types[i].scalar_type.name));
      rb_hash_aset(rb_hash, CSTR2SYM("description"), check_for_string(types[i].scalar_type.description));
    }
    else {
      printf("Error: Unknown type %s", types[i].typename);
      exit(1);
    }

    rb_ary_push(rb_definitions, rb_hash);
  }

  return rb_definitions;
}

void Init_graphqlidlparser()
{
  rb_mGraphQL = rb_define_module("GraphQL");
  rb_cGraphQLIDLParser = rb_define_class_under(rb_mGraphQL, "IDLParser", rb_cObject);

  rb_define_method(rb_cGraphQLIDLParser, "process", GRAPHQLIDLPARSERPROCESS_process, 0);
}
