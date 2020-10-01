import options
import parsecfg
import unittest
import "services/teratail/config"


suite "TeratailConfig from dict":
  test "No config":
    let dict = newConfig()
    let cfg = fromDict(dict)
    check cfg.isNone() == true

  test "Only username":
    var dict = newConfig()
    dict.setSectionKey("teratail", "username", "example")
    let cfg = fromDict(dict)
    check cfg.isNone() == false
    check cfg.get().username == "example"
    check cfg.get().apiKey.isNone()

  test "With api-key":
    var dict = newConfig()
    dict.setSectionKey("teratail", "username", "example")
    dict.setSectionKey("teratail", "apikey", "example-token")
    let cfg = fromDict(dict)
    check cfg.isNone() == false
    check cfg.get().username == "example"
    check cfg.get().apiKey.get() == "example-token"
