import os
import unittest
import "config"


test "Config can save":
  let saved = getEnv("NIMBLE_TEST_VAR") & DirSep & "test.cfg"
  var cfg = AConfig()
  cfg.saveTo(saved)
  check saved.existsFile()
