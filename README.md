[![Actions Status](https://github.com/m-doughty/Term-Size/actions/workflows/test.yml/badge.svg)](https://github.com/m-doughty/Term-Size/actions)

NAME
====

Term::Size - Get terminal size metrics in Raku

SYNOPSIS
========

```raku
use Term::Size;

my $term-size = Term::Size.new;
$term-size.populate;

$term-size.term-width-px;     # Terminal width in pixels (0 = not detected)
$term-size.term-height-px;    # Terminal height in pixels (0 = not detected)
$term-size.term-width-cells;  # Terminal width in cells (0 = not detected)
$term-size.term-height-cells; # Terminal height in cells (0 = not detected)
$term-size.cell-width-px;     # Cell width in pixels (0 = not detected)
$term-size.cell-height-px;    # Cell height in pixels (0 = not detected)
```

STATUS
------

This module allows retrieval of various terminal size metrics on Mac OS & Linux systems.

It can get this information from the Kitty escape sequence protocol (also supported on Wezterm & Rio) with a fallback to ioctl.

Windows support is not planned at this time as getting cell size on Windows is a nightmare.

EXTERNAL API
============

LLM::Character
--------------

### .populate()

Fetches the terminal information from FFI.

### .term-width-px()

Terminal width in pixels (0 = not detected)

### .term-height-px()

Terminal height in pixels (0 = not detected)

### .term-width-cells()

Terminal width in cells (0 = not detected)

### .term-height-cells()

Terminal height in cells (0 = not detected)

### .cell-width-px()

Cell width in pixels (0 = not detected)

### .cell-height-px()

Cell height in pixels (0 = not detected)

termsize
--------

This module installs a termsize script which can be run from anywhere.

AUTHOR
======

  * Matt Doughty

COPYRIGHT AND LICENSE
=====================

Copyright 2025 Matt Doughty

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

