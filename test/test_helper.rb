$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'graphql-idl-parser'

require 'minitest/autorun'

require 'pry'

FIXTURES_DIR = File.join('test', 'graphql-idl-parser', 'fixtures')
BASIC_FIXTURE = File.join(FIXTURES_DIR, 'basic.graphql')
SCHEMA_FIXTURE = File.join(FIXTURES_DIR, 'schema.graphql')
