import bio_seq
import std/unittest
import std/strutils
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

    test "HD SO unknown":
      var s: SAM
      new(s)
      var line = "@HD	SO:unknown"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.HD
      check s.header.headers[0].SO.isSome
      check s.header.headers[0].SO.get == SOKind.unknown

    test "HD SO unsorted":
      var s: SAM
      new(s)
      var line = "@HD	SO:unsorted"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.HD
      check s.header.headers[0].SO.isSome
      check s.header.headers[0].SO.get == SOKind.unsorted

    test "HD SO queryname":
      var s: SAM
      new(s)
      var line = "@HD	SO:queryname"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.HD
      check s.header.headers[0].SO.isSome
      check s.header.headers[0].SO.get == SOKind.queryname
    
    test "HD SO coordinate":
      var s: SAM
      new(s)
      var line = "@HD	SO:coordinate"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.HD
      check s.header.headers[0].SO.isSome
      check s.header.headers[0].SO.get == SOKind.coordinate

    test "HD GO none":
      var s: SAM
      new(s)
      var line = "@HD	GO:none"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.HD
      check s.header.headers[0].GO.isSome
      check s.header.headers[0].GO.get == GOKind.none


    test "HD GO query":
      var s: SAM
      new(s)
      var line = "@HD	GO:query"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.HD
      check s.header.headers[0].GO.isSome
      check s.header.headers[0].GO.get == GOKind.query

    test "HD GO reference":
      var s: SAM
      new(s)
      var line = "@HD	GO:reference"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.HD
      check s.header.headers[0].GO.isSome
      check s.header.headers[0].GO.get == GOKind.reference

    test "HD GO reference":
      var s: SAM
      new(s)
      var line = "@HD	GO:reference"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.HD
      check s.header.headers[0].GO.isSome
      check s.header.headers[0].GO.get == GOKind.reference

    test "HD defaults":
      var s: SAM
      new(s)
      var line = "@HD	VN:1.0"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.HD
      check s.header.headers[0].VN == "1.0"
      check s.header.headers[0].GO.isSome
      check s.header.headers[0].GO.get == GOKind.none
      check s.header.headers[0].SO.isSome
      check s.header.headers[0].SO.get == SOKind.unknown
     # check not s.header.headers[0].SS == 

    test "SQ SN":
      var s: SAM
      new(s)
      var line = "@SQ	SN:1.2"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.SQ
      check s.header.headers[0].SN == "1.2"
      
    test "SQ LN":
      var s: SAM
      new(s)
      var line = "@SQ	LN:5"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.SQ
      check s.header.headers[0].LN == 5

    test "SQ AH":
      var s: SAM
      new(s)
      var line = "@SQ	AH:arg"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.SQ
      check s.header.headers[0].AH.isSome
      check s.header.headers[0].AH.get == "arg"

    test "SQ AN":
      var s: SAM
      new(s)
      var line = "@SQ	AN:arg1"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.SQ
      check s.header.headers[0].AN.isSome
      check s.header.headers[0].AN.get == @["arg1"]

    test "SQ AN":
      var s: SAM
      new(s)
      var line = "@SQ	AN:arg1,arg2"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.SQ
      check s.header.headers[0].AN.isSome
      check s.header.headers[0].AN.get == @["arg1","arg2"]

    test "SQ AS":
      var s: SAM
      new(s)
      var line = "@SQ	AS:arg"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.SQ
      check s.header.headers[0].AS.isSome
      check s.header.headers[0].AS.get == "arg"

    test "SQ M5":
      var s: SAM
      new(s)
      var line = "@SQ	M5:arg"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.SQ
      check s.header.headers[0].M5.isSome
      check s.header.headers[0].M5.get == "arg"

    test "SQ SP":
      var s: SAM
      new(s)
      var line = "@SQ	SP:arg"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.SQ
      check s.header.headers[0].SP.isSome
      check s.header.headers[0].SP.get == "arg"

    test "SQ TP cicular":
      var s: SAM
      new(s)
      var line = "@SQ	TP:circular"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.SQ
      check s.header.headers[0].TP.isSome
      check s.header.headers[0].TP.get == TPKind.circular
    
    test "SQ TP linear":
      var s: SAM
      new(s)
      var line = "@SQ	TP:linear"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.SQ
      check s.header.headers[0].TP.isSome
      check s.header.headers[0].TP.get == TPKind.linear
    
    test "SQ UR":
      var s: SAM
      new(s)
      var line = "@SQ	UR:arg"
      s.parseHeader(line)
      check s.header.headers[0].kind == TagKind.SQ
      check s.header.headers[0].UR.isSome
      check s.header.headers[0].UR.get == "arg"
    

    test "RG":
      discard
    test "PQ":
      discard
    test "CO":
      discard
    test "invalid":
      discard


  suite "parse sam header files":
    test "HD & SQ":
      var s: SAM
      new(s)
      new(s.header)
      var file = readLines("tests/files/sam/syntax/header_1.sam", 4)
      for line in file:
        s.parseHeader(line)

      check s.header.headers[0].kind == TagKind.HD
      check s.header.headers[1].kind == TagKind.SQ
      check s.header.headers[2].kind == TagKind.SQ
      check s.header.headers[3].kind == TagKind.SQ


samHeaderParsing()
