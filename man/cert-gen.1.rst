==============
tmcsplit
==============

--------------------------------------------------------
The Martian Company's Split
--------------------------------------------------------
:Version: tmcsplit |version|
:Manual section: 1

Synopsis
========

tmcsplit *option* *[arguments]*


Description
===========

Javascript GNU Split
implementation.


Options
========

-s input num-parts      Split the input file in
                        the given number of parts.
-x input size-max       Split the input file into
                        multiple parts with maximum
                        file size of max_size bytes.
-m output [parts]       Merge the given parts into
                        the output file.

-h                      Display help.


Examples
============

split \
  -a \
  "input.bin" \
  5

split-file \
  -x \
  "input.bin" \
  457000

split-file \
  -m \
  "output.bin" \
  "part1" "part2" ...


Bugs
====

https://github.com/themartiancompany/node-split-file/-/issues

Copyright
=========

Copyright Tom Valk, Pellegrino Prevete. AGPL-3.0.

See also
========

* split
* tmcsplit
* tmccat

.. include:: variables.rst
