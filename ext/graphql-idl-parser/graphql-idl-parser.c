#include <graphql-idl-parser.h>

static VALUE rb_mGraphQL;
static VALUE rb_cGraphQLIDLParser;

static VALUE GRAPHQLIDLPARSERPROCESS_init(VALUE self)
{
  return self;
}

static VALUE GRAPHQLIDLPARSERPROCESS_process(VALUE self)
{
  return INT2NUM(4);
}

void Init_graphqlidlparser()
{
  rb_mGraphQL = rb_define_module("GraphQL");
  rb_cGraphQLIDLParser = rb_define_class_under(rb_mGraphQL, "IDLParser", rb_cObject);

  rb_define_method(rb_cGraphQLIDLParser, "process", GRAPHQLIDLPARSERPROCESS_process, 0);
}
