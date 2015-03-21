require 'rbconfig'
require 'mkmf'

have_header('ruby.h')

if RbConfig::CONFIG['CC'] == 'gcc'
  $CFLAGS << ' -Wextra -Wall -pedantic'

  if ENV['DEBUG']
    $CFLAGS << ' -O0 -g'
  else
    $CFLAGS << ' -O3'
  end
end

create_makefile('liboga')
