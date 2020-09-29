import cligen
import "commands/info"
import "commands/init"
import "commands/pull"
import "meta"

# Entry point
when isMainModule:
  clCfg.version = meta.version
  dispatchMulti(
    [info.main, cmdName = "info"],
    [init.main, cmdName = "init"],
    [pull.main, cmdName = "pull"],
  )
