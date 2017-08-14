require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rake/clean'
require 'rake/extensiontask'

task default: :test

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

# Gem Spec
gem_spec = Gem::Specification.load('graphql-idl-parser.gemspec')

Rake::ExtensionTask.new('graphql-idl-parser', gem_spec) do |ext|
  ext.name = 'graphqlidlparser'
  ext.lib_dir =  File.join('lib', 'graphql-idl-parser')
end

desc 'Pretty format C code'
task :format do
  puts `astyle --indent=spaces=2 --style=1tbs --keep-one-line-blocks \
        $(ack -n -f --type=cpp --type=cc ext/graphql-idl-parser/)`
end

desc 'Benchmark loading an IDL file'
task :benchmark do
  require 'benchmark'
  require 'graphql'
  require 'graphql-idl-parser'

  schema = File.read(File.join('ext', 'graphql-idl-parser', 'graphql-idl-parser', 'test', 'github.graphql'))

  Benchmark.bm(10) do |x|
    x.report('this-gem: ') { parser = GraphQL::IDLParser.new(schema: schema); parser.process }
  end
end
