import std/macros
import fusion/astdsl

macro generateParser*(c: char, k: openarray[char], v: typed): untyped = 
  ## Generates case statement for parsing nucleotide characters 
  ## 
  ## Generated code:
  ## 
  ## case c
  ## of 'A':
  ##   result = DNA(0)
  ## \...
  ## else:
  ##   raise newException(ValueError, "Invalid " & $DNA & "character: \'" & c)
  template raiseValueError(v, c: untyped) =
    raise newException(ValueError, "Invalid " & $v & "character: '" & c) 
  result = buildAst(stmtList):
    let
      k = k.getImpl
    caseStmt(c):
      for i in 0 ..< k.len: 
        ofBranch(k[i]):
          asgn(newIdentNode("result"), newCall(v, newIntLitNode(i))) 
      `else`:
        getAst(raiseValueError(v, c))
  # echo result.repr