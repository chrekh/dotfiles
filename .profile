if [ -z "$BASH" -o "$BASH" = /bin/sh ]; then
  [ -x /bin/bash ] && exec /bin/bash -l
  [ -x /usr/bin/bash ] && exec /usr/bin/bash -l
  [ -x /usr/local/bin/bash ] && exec /usr/local/bin/bash -l
fi
