#include "graphql-idl-parser.h"

static VALUE rb_mGraphQL;
static VALUE rb_cGraphQLIDLParser;

VALUE convert_string(const char* c_string) {
  if (c_string == NULL) {
    return Qnil;
  }

  VALUE rb_string = rb_str_new2(c_string);
  int enc = rb_enc_find_index("UTF-8");
  rb_enc_associate_index(rb_string, enc);

  return rb_string;
}

VALUE convert_array_of_strings(struct array_of_strings c_array_of_strings) {
  VALUE rb_array = rb_ary_new();
  if (c_array_of_strings.length == 0) {
    return rb_array;
  }

  for (size_t i = 0; i < c_array_of_strings.length; i++) {
    rb_ary_push(rb_array, convert_string(c_array_of_strings.data[i]));
  }

  return rb_array;
}

VALUE convert_type_info(struct FieldType c_field_type) {
  VALUE rb_hash = rb_hash_new();

  rb_hash_aset(rb_hash, CSTR2SYM("name"), convert_string(c_field_type.name));
  rb_hash_aset(rb_hash, CSTR2SYM("info"), convert_string(c_field_type.info));

  return rb_hash;
}

VALUE convert_array_of_arguments(struct array_of_arguments c_array_of_arguments) {
  VALUE rb_array = rb_ary_new();
  if (c_array_of_arguments.length == 0) {
    return rb_array;
  }

  for (size_t i = 0; i < c_array_of_arguments.length; i++) {
    VALUE rb_hash = rb_hash_new();

    rb_hash_aset(rb_hash, CSTR2SYM("name"), convert_string(c_array_of_arguments.data[i].name));
    rb_hash_aset(rb_hash, CSTR2SYM("description"), convert_string(c_array_of_arguments.data[i].description));
    rb_hash_aset(rb_hash, CSTR2SYM("type_info"), convert_type_info(c_array_of_arguments.data[i].type_info));

    rb_ary_push(rb_array, rb_hash);
  }

  return rb_array;
}

VALUE convert_array_of_fields(struct array_of_fields c_array_of_fields) {
  VALUE rb_array = rb_ary_new();
  if (c_array_of_fields.length == 0) {
    return rb_array;
  }

  for (size_t i = 0; i < c_array_of_fields.length; i++) {
    VALUE rb_hash = rb_hash_new();
    rb_hash_aset(rb_hash, CSTR2SYM("name"), convert_string(c_array_of_fields.data[i].name));
    rb_hash_aset(rb_hash, CSTR2SYM("description"), convert_string(c_array_of_fields.data[i].description));
    rb_hash_aset(rb_hash, CSTR2SYM("type_info"), convert_type_info(c_array_of_fields.data[i].type_info));
    rb_hash_aset(rb_hash, CSTR2SYM("arguments"), convert_array_of_arguments(c_array_of_fields.data[i].arguments));
    rb_hash_aset(rb_hash, CSTR2SYM("deprecated"), c_array_of_fields.data[i].deprecated ? Qtrue : Qfalse);
    rb_hash_aset(rb_hash, CSTR2SYM("deprecation_reason"), convert_string(c_array_of_fields.data[i].deprecation_reason));

    rb_ary_push(rb_array, rb_hash);
  }

  return rb_array;
}

VALUE convert_array_of_values(struct array_of_values c_array_of_values) {
  VALUE rb_array = rb_ary_new();
  if (c_array_of_values.length == 0) {
    return rb_array;
  }

  for (size_t i = 0; i < c_array_of_values.length; i++) {
    VALUE rb_hash = rb_hash_new();
    rb_hash_aset(rb_hash, CSTR2SYM("name"), convert_string(c_array_of_values.data[i].name));
    rb_hash_aset(rb_hash, CSTR2SYM("description"), convert_string(c_array_of_values.data[i].description));

    rb_ary_push(rb_array, rb_hash);
  }

  return rb_array;
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
      rb_hash_aset(rb_hash, CSTR2SYM("typename"), convert_string(types[i].typename));
      rb_hash_aset(rb_hash, CSTR2SYM("name"), convert_string(types[i].scalar_type.name));
      rb_hash_aset(rb_hash, CSTR2SYM("description"), convert_string(types[i].scalar_type.description));
    }
    else if (strcmp(types[i].typename, "object") == 0) {
      rb_hash_aset(rb_hash, CSTR2SYM("typename"), convert_string(types[i].typename));
      rb_hash_aset(rb_hash, CSTR2SYM("name"), convert_string(types[i].object_type.name));
      rb_hash_aset(rb_hash, CSTR2SYM("description"), convert_string(types[i].object_type.description));
      rb_hash_aset(rb_hash, CSTR2SYM("implements"), convert_array_of_strings(types[i].object_type.implements));
      rb_hash_aset(rb_hash, CSTR2SYM("fields"), convert_array_of_fields(types[i].object_type.fields));
    }
    else if (strcmp(types[i].typename, "enum") == 0) {
      rb_hash_aset(rb_hash, CSTR2SYM("typename"), convert_string(types[i].typename));
      rb_hash_aset(rb_hash, CSTR2SYM("name"), convert_string(types[i].enum_type.name));
      rb_hash_aset(rb_hash, CSTR2SYM("description"), convert_string(types[i].enum_type.description));
      rb_hash_aset(rb_hash, CSTR2SYM("values"), convert_array_of_values(types[i].enum_type.values));
    }
    else if (strcmp(types[i].typename, "interface") == 0) {
      rb_hash_aset(rb_hash, CSTR2SYM("typename"), convert_string(types[i].typename));
      rb_hash_aset(rb_hash, CSTR2SYM("name"), convert_string(types[i].interface_type.name));
      rb_hash_aset(rb_hash, CSTR2SYM("description"), convert_string(types[i].interface_type.description));
      rb_hash_aset(rb_hash, CSTR2SYM("fields"), convert_array_of_fields(types[i].interface_type.fields));
    }
    else if (strcmp(types[i].typename, "union") == 0) {
      rb_hash_aset(rb_hash, CSTR2SYM("typename"), convert_string(types[i].typename));
      rb_hash_aset(rb_hash, CSTR2SYM("name"), convert_string(types[i].union_type.name));
      rb_hash_aset(rb_hash, CSTR2SYM("description"), convert_string(types[i].union_type.description));
      rb_hash_aset(rb_hash, CSTR2SYM("values"), convert_array_of_strings(types[i].union_type.values));
    }
    else if (strcmp(types[i].typename, "input_object") == 0) {
      rb_hash_aset(rb_hash, CSTR2SYM("typename"), convert_string(types[i].typename));
      rb_hash_aset(rb_hash, CSTR2SYM("name"), convert_string(types[i].input_object_type.name));
      rb_hash_aset(rb_hash, CSTR2SYM("description"), convert_string(types[i].input_object_type.description));
      rb_hash_aset(rb_hash, CSTR2SYM("fields"), convert_array_of_fields(types[i].input_object_type.fields));
    }
    else {
      printf("\nError: Unknown type %s\n", types[i].typename);
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
