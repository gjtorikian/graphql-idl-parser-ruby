#include <graphql-idl-parser.h>

static VALUE rb_cGraphQLIDLParser;
static VALUE rb_cGraphQLIDLParserProcess;

static VALUE GRAPHQLIDLPARSERPROCESS_init(VALUE self)
{
  return self;
}

static VALUE GRAPHQLIDLPARSERPROCESS_process(VALUE self)
{
  return INT2NUM(dogcow());
}

void Init_graphqlidlparser()
{
  rb_cGraphQLIDLParser = rb_define_class("GraphQLIDLParser", rb_cObject);

  rb_cGraphQLIDLParserProcess = rb_define_class_under(rb_cGraphQLIDLParser, "Parser", rb_cObject);

  rb_define_method(rb_cGraphQLIDLParserProcess, "initialize", GRAPHQLIDLPARSERPROCESS_init, 0);
  rb_define_method(rb_cGraphQLIDLParserProcess, "process", GRAPHQLIDLPARSERPROCESS_process, 0);
}
