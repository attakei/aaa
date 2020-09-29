import os
import unittest
import "config"
import "meta"


suite "Config in/out":
  test "Config can save":
    let saved = getEnv("NIMBLE_TEST_VAR") & DirSep & "test.cfg"
    var cfg = AConfig()
    cfg.saveTo(saved)
    check saved.getFileSize() > 0

  test "Config loadings":
    let src = getEnv("NIMBLE_TEST_DIR") & DirSep & "testdata/regular.cfg"
    let cfg = loadConfig(src)
    check cfg.version == meta.version
