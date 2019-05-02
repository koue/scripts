# -*- coding: utf-8 -*-

import sys
import re

from myte import myte

if len(sys.argv) < 3:
    print "Usage: python %s [commands_file] [layout_file]" % sys.argv[0]
    print "Example: python %s tests/commands.txt tests/if.txt" % sys.argv[0]
    sys.exit(1)

for line in myte.runme(sys.argv[1], sys.argv[2]):
    print line
