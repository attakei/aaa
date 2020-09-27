## .nibmle file import as metadata
## ===============================
## 
## This module has role only to use .nimble file as component.
## If you update ``aaa.nimble``, must edit this to adjust behavior.
var
  version*: string
  author: string
  description: string
  license: string
  srcdir: string
  binDir: string
  bin: seq[string]

proc requires(deps: varargs[string]) = discard

include "../aaa.nimble"
