require 'mkmf'

have_header('ruby.h')

$CFLAGS << ' -Wextra -Wall -pedantic'

if ENV['DEBUG']
  $CFLAGS << ' -O0'
else
  $CFLAGS << ' -O3 -g'
end

create_makefile('liboga/liboga')
