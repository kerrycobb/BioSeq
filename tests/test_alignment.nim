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