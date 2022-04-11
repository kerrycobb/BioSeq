import random
import sequtils
import strutils
import times
import ../src/bioseq




template benchmark(benchmarkName: string, code: untyped) =
  block:
    let t0 = epochTime()
    code
    let elapsed = epochTime() - t0
    let elapsedStr = elapsed.formatFloat(format = ffDecimal, precision = 3)
    echo "CPU Time [", benchmarkName, "] ", elapsedStr, "s"


var seqs: seq[seq[DNA]] 
for i in 0 ..< 1000:
  seqs.add(newSeqWith(1_000_000, sample(@[dnaT, dnaC, dnaG, dnaA])))


# benchmark "single pointer":
#   for i in 0 ..< int(1e5):
#     var a: SPAlignment[DNA] 
#     for i in seqs:
#       a = spalignment(1000, 1000, i)


# benchmark "multi pointer":
#   for i in 0 ..< int(1e5):
#     var a: Alignment[DNA]
#     for i in seqs:
#       a = alignment(1000, 10000, i)

# CPU Time [single pointer] 4.391s, 4.680s
# CPU Time [multi pointer] 42.835s, 51.219s


var 
  spaligns = newSeq[SPAlignment[DNA]](seqs.len)
  aligns = newSeq[Alignment[DNA]](seqs.len)
for i in 0 ..< seqs.len:
  spaligns[i] = spalignment(1000, 1000, seqs[i])
  aligns[i] = alignment(1000, 1000, seqs[i])


benchmark "singl pointer items":
  var v: DNA
  for i in 0 ..< int(1e1):
    for ai in 0 ..< spaligns.len: 
      for bi in spaligns[ai]: 
        v = bi

benchmark "multi pointer items":
  var v: DNA
  for i in 0 ..< int(1e1):
    for ai in 0 ..< aligns.len: 
      for bi in aligns[ai]: 
        v = bi

benchmark "reverse singl pointer":
  for i in 0 ..< int(1e3):
    for i in 0 ..< spaligns.len:
      spaligns[i].reverse

benchmark "reverse multi pointer":
  for i in 0 ..< int(1e3):
    for i in 0 ..< aligns.len:
      aligns[i].reverse

# CPU Time [singl pointer items] 10.886s, 11.582s
# CPU Time [multi pointer items] 11.376s, 11.932s
# CPU Time [reverse singl pointer] 0.004s, 0.004s
# CPU Time [reverse multi pointer] 3.823s, 4.327s
