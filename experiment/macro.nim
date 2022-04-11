import std/macros
import fusion/astdsl
import std/sequtils

type
  MyInt* = distinct uint8 

const 
  aa = ['a', 'b', 'c', 'd']
  bb = [1, 2, 3, 4].mapLiterals(MyInt)

macro m*(n, a, b: typed): untyped = 
  template raiseValueError(x: untyped) =
    raise newException(ValueError, "Invalid value: " & x)
  let
    a = a.getImpl
    b = b.getImpl
  result = buildAst(stmtList):
    caseStmt(n):
      for i in 0 ..< a.len: 
        ofBranch(a[i]):
          asgn(newIdentNode("result"), b[i])
      `else`:
        if n.getTypeInst.repr == "MyInt":
          getAst(raiseValueError(parseStmt("$cast[uint8](" & n.repr & ")")))
          # getAst(raiseValueError(nnkCast.newTree(newIdentNode("uint8"), n)))
        else:
          getAst(raiseValueError(n))
  echo result.repr



###### Test versions, can delete later
# Without dslast module
# Each part separate, don't know how to join them
  # # Case  
  # let csSt = nnkCaseStmt.newTree(x)
  # echo csSt.repr
  # # Of
  # for i in 0 ..< a.len:
  #   let ofBr = nnkOfBranch.newTree(a[i], nnkStmtList.newTree(nnkAsgn.newTree(
  #       newIdentNode("result"), b[i]))) 
  #   echo ofBr.repr
  # # Else
  # let elseBr = nnkElse.newTree(nnkStmtList.newTree(getAst(raiseInvalidChar(x)))) 
  # echo elseBr.repr

# # Without dslast module
# # Doesn't have loop but compiles to complete case statement
#   result = nnkCaseStmt.newTree(x, nnkOfBranch.newTree(a[0], nnkStmtList.newTree(
#       nnkAsgn.newTree(newIdentNode("result"), b[0]))), nnkElse.newTree(
#       nnkStmtList.newTree(getAst(raiseInvalidChar(x)))))
#   echo result.repr

# proc toInt(v: char): MyInt = 
#   m(v, aa, bb)

# proc toChar(v: MyInt): char = 
#   m(v, bb, aa)

# var 
#   i = toInt('a')
#   c = toChar(1.MyInt)

# echo i.int
# echo c
