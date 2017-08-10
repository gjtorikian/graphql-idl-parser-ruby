require 'test_helper'

module GraphQL
  class IDLParserTest < Minitest::Test
    def test_it_demands_string_filename
      assert_raises TypeError do
        GraphQL::IDLParser.new(43)
      end
    end

    def test_it_needs_a_file_that_exists
      assert_raises ArgumentError do
        GraphQL::IDLParser.new("not/a/real/file")
      end
    end

    def test_it_parses_a_basic_schema
      parser = GraphQL::IDLParser.new(BASIC_FIXTURE)
      # debugger
      results = parser.process
      assert_equal 4, results
    end
  end
end
