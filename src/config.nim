import parsecfg
import "meta"


type
  AConfig* = ref object
    ## Configurations
    version: string


proc version*(c: AConfig): string {.inline.} = c.version
  ## Read-only accessor for AConfig.version.


proc createConfig*(): AConfig =
  ## Create new config.
  result = AConfig()
  result.version = meta.version


proc loadConfig*(filepath: string): AConfig =
  ## Load config struct from specified filepath.
  result = AConfig()
  let dict = parsecfg.loadConfig(filepath)
  result.version = dict.getSectionValue("aaa", "version")


proc saveTo*(cfg: AConfig, filepath: string) =
  ## Save config to local file by parsecfg
  var dict = newConfig()
  dict.setSectionKey("aaa", "version", cfg.version)
  dict.writeConfig(filepath)
