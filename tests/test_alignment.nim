import bioseq
import std/unittest
import std/strutils

suite "Alignment":
  test "filterColumns":
    let 
      phyString = """
        3 6 
        Sample1 AN-?NV
        Sample2 AN-?-V
        Sample3 AN-??V
        """
      expected = """
      3 1
      Sample1 A
      Sample2 A
      Sample3 A""".dedent
      inAlign = parsePhylipString(phyString, DNA, Sequential)
      filtered = inAlign.filterColumns({dnaN, dnaUnk, dnaGap, dnaV})
      filteredStr = filtered.toPhylipString(Sequential)
    check filteredStr == expected

  test "alleleCount": 
    let a = newAlignment[DNA](4, 10, 
      @["Sample1", "Sample2", "Sample3", "Sample4"], 
      @[
        "NAAAAARRVV", 
        "?AAATTARAV", 
        "-A?T-GGRGV", 
        "-A-T?CGRCV"].join.toSeq(DNA))

    check a.alleleCount(0) == 0
    check a.alleleCount(1) == 1
    check a.alleleCount(2) == 1
    check a.alleleCount(3) == 2  
    check a.alleleCount(4) == 2 
    check a.alleleCount(5) == 4
    check a.alleleCount(6) == 2
    check a.alleleCount(7) == 2
    check a.alleleCount(8) == 3
    check a.alleleCount(9) == 3
  
  let 
    phyString = """
      4 31 
      Sample1   ATGC ATGC AC RR MM WW SS KK YY RRR N-? AAA
      Sample2   ATGC N?-N TG AG AC AT GC GT CT N?- N-? TTA
      Sample3   ATGC N?-? NN AG AC AT GC GT CT N?- N-? GTA
      Sample4   ATGC N?-- ?? AG AC AT GC GT CT N?- N-? GRV
      """
    align = parsePhylipString(phyString, DNA, Sequential)

  test "Character count":
    var 
      aCounts: seq[int]
      missCounts: seq[int]
    for i in 0 ..< align.nseqs: 
      aCounts.add(align.rowCharacterCount(i, {dnaA}))
      missCounts.add(align.rowCharacterCount(i, {dnaGap, dnaUnk, dnaN}))
    check aCounts == @[6, 5, 5, 4]
    check missCounts == @[3, 10, 12, 12]