## "info" sub command behavior
import os
import terminal
import "../config"


template withTerminalStyle(
  fg: ForegroundColor,
  body: untyped
): untyped =
  # Block context to change termial styles
  when fg != fgDefault:
    setForegroundColor(stdout, fg)
  body
  resetAttributes(stdout)
  

proc main*(output: string): int =
  ## Initialize environment
  result = 1  # Always return 0
  addQuitProc(resetAttributes)

  # Display welcome message
  withTerminalStyle(fgGreen):
    echo("============================")
    echo("      ___     ___     ___   ")
    echo("     /   |   /   |   /   |  ")
    echo("    / /| |  / /| |  / /| |  ")
    echo("   / ___ | / ___ | / ___ |  ")
    echo("  /_/  |_|/_/  |_|/_/  |_|  ")
    echo("============================")
    echo("Start initialize aaa configurations.")
    echo("This configuration will save to '" & output & "'")
  echo("")

  let outputPath = os.absolutePath(output)
  if not parentDir(outputPath).existsDir():
    withTerminalStyle(fgRed):
      echo("Output directory must be already exists.")
      return 1
  if outputPath.existsFile():
    withTerminalStyle(fgRed):
      echo("Config file is already exists!")
      return 1

  # Write phase
  var cfg = createConfig()
  cfg.saveTo(outputPath)
