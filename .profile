if [ -z "$BASH" -a -x /usr/local/bin/bash ]; then
    exec /usr/local/bin/bash -l
fi
