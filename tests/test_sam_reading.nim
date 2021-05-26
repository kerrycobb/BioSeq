import bio_seq
import std/unittest
import std/sequtils
import std/options

proc samHeaderParsing()=
  suite "parse sam header":
    test "HD VN":
      var s: SAM
      new(s)
      var line = "@HD	VN:1.0"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.HD
      check s.header.headers[0].VN == "1.0"

    test "HD SO":
      var s: SAM
      new(s)
      var line = "@HD	SO:coordinate"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.HD
      check s.header.headers[0].SO.isSome
      check s.header.headers[0].SO.get == SOKind.coordinate


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
