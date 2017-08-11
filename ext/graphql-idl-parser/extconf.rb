require 'fileutils'
require 'mkmf'
require 'rbconfig'
include FileUtils

LIBDIR       = RbConfig::CONFIG['libdir']
INCLUDEDIR   = RbConfig::CONFIG['includedir']
EXT_DIR      = File.expand_path(File.join(File.dirname(__FILE__), 'graphql-idl-parser'))
FFI_DIR      = File.expand_path(File.join(EXT_DIR, 'graphql-idl-parser-ffi'))
HEADER_DIR   = File.expand_path(File.join(EXT_DIR, 'graphql-idl-parser-ffi', 'includes'))
RELEASE_DIR  = File.join(FFI_DIR, 'target', 'release')

def ext
  host_os = RbConfig::CONFIG['host_os']
  case host_os
  when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
    '.dll'
  when /darwin|mac os/
    '.dylib'
  when /linux/
    '.so'
  when /solaris|bsd/
    '.so'
  else
    raise Error::WebDriverError, "unknown os: #{host_os.inspect}"
  end
end

if !system('cargo --version') || !system('rustc --version')
  raise '\n\n\n[ERROR]: You have to install Rust with Cargo (https://www.rust-lang.org/)'
end

type = ENV['TRAVIS'] ? '' : '--release'

`cargo build #{type} --manifest-path #{File.join(FFI_DIR, 'Cargo.toml')}`

$LIBS << ' -lgraphqlidlparser'

HEADER_DIRS = [INCLUDEDIR, HEADER_DIR]
LIB_DIRS = [LIBDIR]

dir_config('graphql-idl-parser', HEADER_DIRS, LIB_DIRS)

find_header('mtex2MML.h', HEADER_DIR)

flag = ENV['TRAVIS'] ? '-O0' : '-O2'

$LDFLAGS << " -L#{RELEASE_DIR}"
$CFLAGS << " #{flag} -I#{HEADER_DIR} -std=c11 -Wall -pedantic -Werror -Wfatal-errors -Wstrict-aliasing"

create_makefile('graphql-idl-parser/graphqlidlparser')
