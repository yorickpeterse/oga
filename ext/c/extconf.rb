require 'mkmf'

have_header('ruby.h')

$CFLAGS << ' -Wextra -Wall -pedantic'

if ENV['DEBUG']
  $CFLAGS << ' -O0 -g'
else
  $CFLAGS << ' -O3'
end

create_makefile('liboga')
