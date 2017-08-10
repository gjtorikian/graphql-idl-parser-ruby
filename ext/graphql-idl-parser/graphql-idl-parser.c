#include "graphql-idl-parser.h"

static VALUE rb_mGraphQL;
static VALUE rb_cGraphQLIDLParser;

static VALUE GRAPHQLIDLPARSERPROCESS_init(VALUE self)
{
  return self;
}

static VALUE GRAPHQLIDLPARSERPROCESS_process(VALUE self)
{
  VALUE rb_schema = rb_iv_get(self, "@schema");
  const char *schema = StringValueCStr(rb_schema);
  GraphQLTypes* types = NULL;
  size_t types_len = 0;
  uint8_t err;

  err = gqlidl_parse_schema(schema, &types, &types_len);

  if (err > 0) {
    printf("Error: Return code %d", err);
    exit(err);
  }

  for (size_t i = 0; i < types_len; i++) {
    printf("typename: %s\n", types[i].typename);
  }

  return INT2NUM(4);
}

void Init_graphqlidlparser()
{
  rb_mGraphQL = rb_define_module("GraphQL");
  rb_cGraphQLIDLParser = rb_define_class_under(rb_mGraphQL, "IDLParser", rb_cObject);

  rb_define_method(rb_cGraphQLIDLParser, "process", GRAPHQLIDLPARSERPROCESS_process, 0);
}
