import ../src/bioseq

block:
  var 
    ds = @[dnaA, dnaC, dnaG, dnaT, dnaT]
    s = sequence(ds)
    ts: seq[DNA] 
  for i in s: ts.add(i)
  assert ts == ds
  assert len(s) == 5

# Sequence reverse
block:
  var 
    ds = @[dnaA, dnaC, dnaG, dnaT, dnaT]
    s = sequence(ds)
    ts: seq[DNA]
  reverse(s)
  reverse(s)
  for i in s: ts.add(i)
  assert ts == ds

# Sequence Complement
block:
  var 
    ds = @[dnaA, dnaC, dnaG, dnaT, dnaT]
    s = sequence(ds)
    ts: seq[DNA]
  complement(s)
  complement(s)
  for i in s: ts.add(i)
  assert ts == ds

# Sequence Reverse Complement
block:
  var 
    ds = @[dnaA, dnaC, dnaG, dnaT, dnaT]
    s = sequence(ds)
    ts: seq[DNA]
  reverseComplement(s)
  reverseComplement(s)
  for i in s: ts.add(i)
  assert ts == ds
  
################################################################################
# Single Pointer Alignments

# Alignment item iterator, nseq, nchar
block:
  var 
    ds = @[dnaA, dnaC, dnaG, dnaT, dnaT, dnaA, dnaC, dnaG, dnaT, dnaT]
    a = spalignment(2, 5, ds)
    ts: seq[DNA] 
  for i in a: ts.add(i)
  assert ts == ds
  assert nseq(a) == 2
  assert nchar(a) == 5

# Alignment reverse
block:
  var 
    ds = @[dnaA, dnaC, dnaG, dnaT, dnaT, dnaA, dnaC, dnaG, dnaT, dnaT]
    a = spalignment(2, 5, ds)
    ts: seq[DNA]
  reverse(a)
  reverse(a)
  for i in a: ts.add(i)
  assert ts == ds

# Alignment Complement
block:
  var 
    ds = @[dnaA, dnaC, dnaG, dnaT, dnaT, dnaA, dnaC, dnaG, dnaT, dnaT]
    a = spalignment(2, 5, ds)
    ts: seq[DNA]
  complement(a)
  complement(a)
  for i in a: ts.add(i)
  assert ts == ds

# Alignment Reverse Complement
block:
  var 
    ds = @[dnaA, dnaC, dnaG, dnaT, dnaT, dnaA, dnaC, dnaG, dnaT, dnaT]
    a = spalignment(2, 5, ds)
    ts: seq[DNA]
  reverseComplement(a)
  reverseComplement(a)
  for i in a: ts.add(i)
  assert ts == ds


################################################################################
# Multi Pointer Alignments

# Alignment item iterator, nseq, nchar
block:
  var 
    ds = @[dnaA, dnaC, dnaG, dnaT, dnaT, dnaA, dnaC, dnaG, dnaT, dnaT]
    a = alignment(2, 5, ds)
    ts: seq[DNA] 
  for i in a: 
    ts.add(i)
  assert ts == ds
  assert nseq(a) == 2
  assert nchar(a) == 5

# Alignment reverse
block:
  var 
    ds = @[dnaA, dnaC, dnaG, dnaT, dnaT, dnaA, dnaC, dnaG, dnaT, dnaT]
    a = alignment(2, 5, ds)
    ts: seq[DNA]
  reverse(a)
  reverse(a)
  for i in a: ts.add(i)
  assert ts == ds

# Alignment Complement
block:
  var 
    ds = @[dnaA, dnaC, dnaG, dnaT, dnaT, dnaA, dnaC, dnaG, dnaT, dnaT]
    a = alignment(2, 5, ds)
    ts: seq[DNA]
  complement(a)
  complement(a)
  for i in a: ts.add(i)
  assert ts == ds

# Alignment Reverse Complement
block:
  var 
    ds = @[dnaA, dnaC, dnaG, dnaT, dnaT, dnaA, dnaC, dnaG, dnaT, dnaT]
    a = alignment(2, 5, ds)
    ts: seq[DNA]
  reverseComplement(a)
  reverseComplement(a)
  for i in a: ts.add(i)
  assert ts == ds