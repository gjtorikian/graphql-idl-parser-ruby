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
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.extensions    = ['ext/graphql-idl-parser/extconf.rb']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'graphql', '~> 1.6'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rake-compiler', '~> 0.9'
end
