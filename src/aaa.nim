import cligen
import "commands/info"
import "meta"

# Entry point
when isMainModule:
  clCfg.version = meta.version
  dispatchMulti([
    info.main, cmdName = "info"
  ])
