#!/bin/sh
#
[ -z ${1} ] && echo "Usage: ${0} /path/to/command [parameters]" && exit 1

valgrind  --track-origins=yes --tool=memcheck --leak-check=yes --show-reachable=yes --num-callers=20 $@
