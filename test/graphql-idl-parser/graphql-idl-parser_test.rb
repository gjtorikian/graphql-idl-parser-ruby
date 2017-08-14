require 'test_helper'

module GraphQL
  class IDLParserTest < Minitest::Test
    def test_it_demands_string_argument
      assert_raises TypeError do
        GraphQL::IDLParser.new(filename: 43)
      end

      assert_raises TypeError do
        GraphQL::IDLParser.new(schema: 43)
      end
    end

    def test_it_needs_a_file_that_exists
      assert_raises ArgumentError do
        GraphQL::IDLParser.new(filename: "not/a/real/file")
      end
    end

    def test_it_needs_one_or_the_other
      assert_raises ArgumentError do
        GraphQL::IDLParser.new(filename: File.join(FIXTURES_DIR, 'github.graphql'), schema: "scalar DateTime")
      end

      assert_raises ArgumentError do
        GraphQL::IDLParser.new
      end
    end

    # def test_it_has_a_sanity_check
    #   contents = ''
    #   Dir.glob("#{RUST_FIXTURES_DIR}/**/*.graphql").each do |schema|
    #     contents += File.read(schema)
    #   end
    #   parser = GraphQL::IDLParser.new(schema: contents)
    #   parser.process
    # end

    # def test_it_has_a_github_sanity_check
    #   contents = File.read("#{RUST_FIXTURES_DIR}/github.graphql")
    #   parser = GraphQL::IDLParser.new(schema: contents)
    #   parser.process
    # end
  end
end
