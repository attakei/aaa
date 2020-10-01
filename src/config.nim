import options
import parsecfg
import "meta"
import "services/teratail/config" as teratail_config


type
  AConfig* = ref object
    ## Configurations
    version: string
    teratail: Option[TeratailConfig]


proc version*(c: AConfig): string {.inline.} = c.version
  ## Read-only accessor for AConfig.version.

proc teratail*(self: AConfig): Option[TeratailConfig] {.inline.} = self.teratail


proc createConfig*(): AConfig =
  ## Create new config.
  result = AConfig()
  result.version = meta.version


proc loadConfig*(filepath: string): AConfig =
  ## Load config struct from specified filepath.
  result = AConfig()
  let dict = parsecfg.loadConfig(filepath)
  result.version = dict.getSectionValue("tact", "version")
  result.teratail = teratail_config.fromDict(dict)

proc saveTo*(cfg: AConfig, filepath: string) =
  ## Save config to local file by parsecfg
  var dict = newConfig()
  dict.setSectionKey("tact", "version", cfg.version)
  if cfg.teratail.isSome:
    cfg.teratail.get.toDict(dict)
  dict.writeConfig(filepath)
