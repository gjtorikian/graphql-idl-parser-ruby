require 'fileutils'
require 'mkmf'
require 'rbconfig'
include FileUtils

LIBDIR       = RbConfig::CONFIG['libdir']
INCLUDEDIR   = RbConfig::CONFIG['includedir']
EXT_DIR      = File.expand_path(File.join(File.dirname(__FILE__), 'graphql-idl-parser'))
FFI_DIR      = File.expand_path(File.join(EXT_DIR, 'graphql-idl-parser-ffi'))
HEADER_DIR   = File.expand_path(File.join(EXT_DIR, 'graphql-idl-parser-ffi', 'includes'))

if ENV['TRAVIS']
  type = 'debug'
  target = ''
  flag = '-O0'
else
  type = 'release'
  target = '--release'
  flag = '-O2'
end

RELEASE_DIR  = File.join(FFI_DIR, 'target', type)

if !system('cargo --version') || !system('rustc --version')
  raise '\n\n\n[ERROR]: You have to install Rust with Cargo (https://www.rust-lang.org/)'
end

`cargo build #{target} --manifest-path #{File.join(FFI_DIR, 'Cargo.toml')}`

$LIBS << ' -lgraphqlidlparser'

HEADER_DIRS = [INCLUDEDIR, HEADER_DIR]
LIB_DIRS = [LIBDIR, RELEASE_DIR]

dir_config('graphql-idl-parser', HEADER_DIRS, LIB_DIRS)

$CFLAGS << " #{flag} -std=c11 -Wall -pedantic -Werror -Wfatal-errors -Wstrict-aliasing"

create_makefile('graphql-idl-parser/graphqlidlparser')
