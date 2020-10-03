import options
import os
import parsecfg
import "meta"
import "services/teratail/config" as teratail_config
import "services/pixela/config" as pixela_config


type
  AConfig* = ref object
    ## Configurations
    version: string
    database: string
    teratail: Option[TeratailConfig]
    pixela: Option[PixelaConfig]


proc version*(c: AConfig): string {.inline.} = c.version
  ## Read-only accessor for AConfig.version.

proc database*(c: AConfig): string {.inline.} = c.database

proc teratail*(self: AConfig): Option[TeratailConfig] {.inline.} = self.teratail

proc pixela*(self: AConfig): Option[PixelaConfig] {.inline.} = self.pixela


proc createConfig*(outputDir: string): AConfig =
  ## Create new config.
  result = AConfig()
  result.version = meta.version
  result.database = outputDir & DirSep & "tact.db"


proc loadConfig*(filepath: string): AConfig =
  ## Load config struct from specified filepath.
  result = AConfig()
  let dict = parsecfg.loadConfig(filepath)
  result.version = dict.getSectionValue("tact", "version")
  result.database = dict.getSectionValue("tact", "database")
  result.teratail = teratail_config.fromDict(dict)
  result.pixela = pixela_config.fromDict(dict)

proc saveTo*(cfg: AConfig, filepath: string) =
  ## Save config to local file by parsecfg
  var dict = newConfig()
  dict.setSectionKey("tact", "version", cfg.version)
  dict.setSectionKey("tact", "database", cfg.database)
  if cfg.teratail.isSome:
    cfg.teratail.get.toDict(dict)
  if cfg.pixela.isSome:
    cfg.pixela.get.toDict(dict)
  dict.writeConfig(filepath)
