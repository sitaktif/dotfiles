#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import print_function

import re
import os
import sys
import fcntl
import select
import subprocess

"""Indent the command passed in argument by four characters.

Notes:
- Trailing newline are not be indented.
- stdout and stderr are collapsed and written to stdout after being indented.
- In order to ensure that we display data incrementally even in the absence of newlines, we
select() the output of the subprocess.
"""

def main():
    p = subprocess.Popen(sys.argv[1:], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

    fd = p.stdout.fileno()
    fl = fcntl.fcntl(fd, fcntl.F_GETFL)
    fcntl.fcntl(fd, fcntl.F_SETFL, fl | os.O_NONBLOCK)

    RE_NEWLINE_AND_CHAR = re.compile(r'\n(?=.)')  # Don't consume the char following the newline

    start_of_line = True
    while True:
        rlist, _, _ = select.select([p.stdout], [], [], 0.1)

        if not(rlist):
            continue  # Nothing to read --> loop

        s = os.read(fd, 2 ** 16)

        if not s:
            break  # EOF --> exit

        if start_of_line:
            sys.stdout.write('    ')
            start_of_line = False

        sys.stdout.write(re.sub(RE_NEWLINE_AND_CHAR, '\n    ', s))

        if s[-1] == '\n':
            start_of_line = True

if __name__ == '__main__':
    main()
