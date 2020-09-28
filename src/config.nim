import parsecfg


type
  AConfig* = ref object


proc createConfig*(): AConfig =
  result = AConfig()


proc saveTo*(cfg: AConfig, filepath: string) =
  ## Save config to local file by parsecfg
  var dict = newConfig()
  dict.writeConfig(filepath)
