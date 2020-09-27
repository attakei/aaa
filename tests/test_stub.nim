## This is stub test to run CI.
## 
## Remove this after some test case for implemented scopes.
import re
import unittest
import "meta"


test "Recognize version info":
  check match(meta.version, re"\d+\.\d+\.\d+")  
