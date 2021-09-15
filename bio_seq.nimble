version     = "0.0.5"
author      = "Kerry A. Cobb"
description = "A Nim library for biological sequence data."
license     = "MIT"
srcDir      = "src"
requires "nim >= 1.2.0", "zip"
task test, "Runs the test suite":
  exec "nim c -r tests/test_sam_reading"
