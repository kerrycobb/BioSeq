import bio_seq
import std/unittest
import std/sequtils

proc samHeaderParsing()=
  suite "parse sam header":
    test "HD":
      var line = "@HD	VN:1.0	SO:coordinate"
      var header = parseHeader(line)
    test "SQ":
      discard
    test "RG":
      discard
    test "PQ":
      discard
    test "CO":
      discard
    test "invalid":
      discard

samHeaderParsing()
