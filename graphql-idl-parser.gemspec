# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'graphql-idl-parser/version'

Gem::Specification.new do |spec|
  spec.name          = 'graphql-idl-parser'
  spec.version       = GraphQLIDLParser::VERSION
  spec.authors       = ['Garen J. Torikian']
  spec.email         = ['gjtorikian@gmail.com']

  spec.summary       = 'A parser for the GraphQL IDL format.'
  spec.homepage      = 'https://www.github.com/gjtorikian/graphql-idl-parser-ruby'

  spec.files         = %w(LICENSE.txt README.md Rakefile graphql-idl-parser.gemspec)
  spec.files        += Dir.glob('lib/**/*.rb')
  spec.files        += Dir['ext/**/*'].reject { |f| f =~ /\.o$/ }
  spec.test_files    = Dir.glob('test/**/*')
  spec.require_paths = %w(lib ext)

  spec.extensions    = ['ext/graphql-idl-parser/extconf.rb']

  spec.add_development_dependency 'benchmark-ips'
  spec.add_development_dependency 'graphql', '~> 1.6'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rake-compiler', '~> 0.9'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-github'
end
