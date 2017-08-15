#include "graphql-idl-parser.h"

static VALUE rb_mGraphQL;
static VALUE rb_cGraphQLIDLParser;
static VALUE rb_cResult;

VALUE convert_string(const char* c_string)
{
  VALUE rb_string;
  int enc;

  if (c_string == NULL) {
    return Qnil;
  }

  rb_string = rb_str_new2(c_string);
  enc = rb_enc_find_index("UTF-8");
  rb_enc_associate_index(rb_string, enc);

  return rb_string;
}

VALUE convert_type_info(struct FieldType c_field_type)
{
  VALUE rb_hash = rb_hash_new();

  rb_hash_aset(rb_hash, CSTR2SYM("name"), convert_string(c_field_type.name));
  rb_hash_aset(rb_hash, CSTR2SYM("info"), convert_string(c_field_type.info));

  return rb_hash;
}

VALUE convert_array_of_strings(struct array_of_strings c_array_of_strings)
{
  VALUE rb_array = rb_ary_new();
  size_t i;

  if (c_array_of_strings.length == 0) {
    return rb_array;
  }

  for (i = 0; i < c_array_of_strings.length; i++) {
    rb_ary_push(rb_array, convert_string(c_array_of_strings.data[i]));
  }

  return rb_array;
}

VALUE convert_array_of_arguments(struct array_of_arguments c_array_of_arguments)
{
  VALUE rb_array = rb_ary_new();
  VALUE rb_hash;
  size_t i;

  if (c_array_of_arguments.length == 0) {
    return rb_array;
  }

  for (i = 0; i < c_array_of_arguments.length; i++) {
    rb_hash = rb_hash_new();

    rb_hash_aset(rb_hash, CSTR2SYM("name"), convert_string(c_array_of_arguments.data[i].name));
    rb_hash_aset(rb_hash, CSTR2SYM("description"), convert_string(c_array_of_arguments.data[i].description));
    rb_hash_aset(rb_hash, CSTR2SYM("type_info"), convert_type_info(c_array_of_arguments.data[i].type_info));
    rb_hash_aset(rb_hash, CSTR2SYM("default_value"), convert_string(c_array_of_arguments.data[i].default_value));
    rb_hash_aset(rb_hash, CSTR2SYM("directives"), convert_array_of_directives(c_array_of_arguments.data[i].directives));

    rb_ary_push(rb_array, rb_hash);
  }

  return rb_array;
}

VALUE convert_array_of_fields(struct array_of_fields c_array_of_fields)
{
  VALUE rb_array = rb_ary_new();
  VALUE rb_hash;
  size_t i;

  if (c_array_of_fields.length == 0) {
    return rb_array;
  }

  for (i = 0; i < c_array_of_fields.length; i++) {
    rb_hash = rb_hash_new();

    rb_hash_aset(rb_hash, CSTR2SYM("name"), convert_string(c_array_of_fields.data[i].name));
    rb_hash_aset(rb_hash, CSTR2SYM("description"), convert_string(c_array_of_fields.data[i].description));
    rb_hash_aset(rb_hash, CSTR2SYM("type_info"), convert_type_info(c_array_of_fields.data[i].type_info));
    rb_hash_aset(rb_hash, CSTR2SYM("arguments"), convert_array_of_arguments(c_array_of_fields.data[i].arguments));
    rb_hash_aset(rb_hash, CSTR2SYM("directives"), convert_array_of_directives(c_array_of_fields.data[i].directives));

    rb_ary_push(rb_array, rb_hash);
  }

  return rb_array;
}

VALUE convert_array_of_values(struct array_of_values c_array_of_values)
{
  VALUE rb_array = rb_ary_new();
  VALUE rb_hash;
  size_t i;

  if (c_array_of_values.length == 0) {
    return rb_array;
  }

  for (i = 0; i < c_array_of_values.length; i++) {
    rb_hash = rb_hash_new();
    rb_hash_aset(rb_hash, CSTR2SYM("name"), convert_string(c_array_of_values.data[i].name));
    rb_hash_aset(rb_hash, CSTR2SYM("description"), convert_string(c_array_of_values.data[i].description));
    rb_hash_aset(rb_hash, CSTR2SYM("directives"), convert_array_of_directives(c_array_of_values.data[i].directives));

    rb_ary_push(rb_array, rb_hash);
  }

  return rb_array;
}

VALUE convert_array_of_directives(struct array_of_directives c_array_of_directives)
{
  VALUE rb_array = rb_ary_new();
  VALUE rb_hash;
  VALUE rb_arguments_array;
  VALUE rb_arguments_hash;

  size_t i, j;

  if (c_array_of_directives.length == 0) {
    return rb_array;
  }

  for (i = 0; i < c_array_of_directives.length; i++) {
    rb_hash = rb_hash_new();
    rb_arguments_array = rb_ary_new();

    rb_hash_aset(rb_hash, CSTR2SYM("name"), convert_string(c_array_of_directives.data[i].name));
    rb_hash_aset(rb_hash, CSTR2SYM("arguments"), rb_arguments_array);

    for (j = 0; j < c_array_of_directives.data[i].arguments.length; j++) {
      rb_arguments_hash = rb_hash_new();
      rb_hash_aset(rb_arguments_hash, CSTR2SYM("name"), convert_string(c_array_of_directives.data[i].arguments.data[j].name));
      rb_hash_aset(rb_arguments_hash, CSTR2SYM("value"), convert_string(c_array_of_directives.data[i].arguments.data[j].value));

      rb_ary_push(rb_arguments_array, rb_arguments_hash);
    }

    rb_ary_push(rb_array, rb_hash);
  }

  return rb_array;
}

static VALUE GRAPHQLIDLPARSERPROCESS_process(VALUE self)
{
  VALUE rb_schema = rb_iv_get(self, "@schema");
  VALUE rb_result = rb_obj_alloc(rb_cResult);
  VALUE rb_types;
  VALUE rb_hash;
  GraphQLTypes* types = NULL;
  size_t types_len = 0;
  uint8_t err;
  const char *schema = StringValueCStr(rb_schema);

  err = gqlidl_parse_schema(schema, &types, &types_len);

  if (err > 0) {
    printf("Error: Return code %d", err);
    exit(err);
  }

  rb_types = rb_ary_new();

  /* attr_reader :types */
  rb_define_attr(rb_cResult, "types", 1, 0);

  for (size_t i = 0; i < types_len; i++) {
    rb_hash = rb_hash_new();

    if (strcmp(types[i].typename, "scalar") == 0) {
      rb_hash_aset(rb_hash, CSTR2SYM("typename"), convert_string(types[i].typename));
      rb_hash_aset(rb_hash, CSTR2SYM("name"), convert_string(types[i].scalar_type.name));
      rb_hash_aset(rb_hash, CSTR2SYM("description"), convert_string(types[i].scalar_type.description));
    } else if (strcmp(types[i].typename, "object") == 0) {
      rb_hash_aset(rb_hash, CSTR2SYM("typename"), convert_string(types[i].typename));
      rb_hash_aset(rb_hash, CSTR2SYM("description"), convert_string(types[i].object_type.description));
      rb_hash_aset(rb_hash, CSTR2SYM("name"), convert_string(types[i].object_type.name));
      rb_hash_aset(rb_hash, CSTR2SYM("implements"), convert_array_of_strings(types[i].object_type.implements));
      rb_hash_aset(rb_hash, CSTR2SYM("directives"), convert_array_of_directives(types[i].object_type.directives));
      rb_hash_aset(rb_hash, CSTR2SYM("fields"), convert_array_of_fields(types[i].object_type.fields));
    } else if (strcmp(types[i].typename, "enum") == 0) {
      rb_hash_aset(rb_hash, CSTR2SYM("typename"), convert_string(types[i].typename));
      rb_hash_aset(rb_hash, CSTR2SYM("description"), convert_string(types[i].enum_type.description));
      rb_hash_aset(rb_hash, CSTR2SYM("name"), convert_string(types[i].enum_type.name));
      rb_hash_aset(rb_hash, CSTR2SYM("directives"), convert_array_of_directives(types[i].enum_type.directives));
      rb_hash_aset(rb_hash, CSTR2SYM("values"), convert_array_of_values(types[i].enum_type.values));
    } else if (strcmp(types[i].typename, "interface") == 0) {
      rb_hash_aset(rb_hash, CSTR2SYM("typename"), convert_string(types[i].typename));
      rb_hash_aset(rb_hash, CSTR2SYM("description"), convert_string(types[i].interface_type.description));
      rb_hash_aset(rb_hash, CSTR2SYM("name"), convert_string(types[i].interface_type.name));
      rb_hash_aset(rb_hash, CSTR2SYM("directives"), convert_array_of_directives(types[i].interface_type.directives));
      rb_hash_aset(rb_hash, CSTR2SYM("fields"), convert_array_of_fields(types[i].interface_type.fields));
    } else if (strcmp(types[i].typename, "union") == 0) {
      rb_hash_aset(rb_hash, CSTR2SYM("typename"), convert_string(types[i].typename));
      rb_hash_aset(rb_hash, CSTR2SYM("description"), convert_string(types[i].union_type.description));
      rb_hash_aset(rb_hash, CSTR2SYM("name"), convert_string(types[i].union_type.name));
      rb_hash_aset(rb_hash, CSTR2SYM("directives"), convert_array_of_directives(types[i].union_type.directives));
      rb_hash_aset(rb_hash, CSTR2SYM("values"), convert_array_of_strings(types[i].union_type.values));
    } else if (strcmp(types[i].typename, "input_object") == 0) {
      rb_hash_aset(rb_hash, CSTR2SYM("typename"), convert_string(types[i].typename));
      rb_hash_aset(rb_hash, CSTR2SYM("description"), convert_string(types[i].input_object_type.description));
      rb_hash_aset(rb_hash, CSTR2SYM("name"), convert_string(types[i].input_object_type.name));
      rb_hash_aset(rb_hash, CSTR2SYM("directives"), convert_array_of_directives(types[i].input_object_type.directives));
      rb_hash_aset(rb_hash, CSTR2SYM("fields"), convert_array_of_fields(types[i].input_object_type.fields));
    } else {
      printf("\nError: Unknown type %s\n", types[i].typename);
      exit(1);
    }

    rb_ary_push(rb_types, rb_hash);
  }

  rb_iv_set(rb_result, "@types", rb_types);
  return rb_result;
}

void Init_graphqlidlparser()
{
  rb_mGraphQL = rb_define_module("GraphQL");
  rb_cGraphQLIDLParser = rb_define_class_under(rb_mGraphQL, "IDLParser", rb_cObject);

  rb_define_method(rb_cGraphQLIDLParser, "process", GRAPHQLIDLPARSERPROCESS_process, 0);

  rb_cResult = rb_define_class_under(rb_cGraphQLIDLParser, "Result", rb_cObject);
}
