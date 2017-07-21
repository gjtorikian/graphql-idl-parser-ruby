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
