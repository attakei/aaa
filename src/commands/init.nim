## "init" sub command behavior
## ===========================
## 
## init command generate configurations file before run main spec.
## 
## If you want to know arguments in command, see ``main()``
import os
import terminal
import norm/sqlite
import "../config"
import "../core/models/activity"


template withTerminalStyle(
  fg: ForegroundColor,
  body: untyped
): untyped =
  ## Block context to change termial styles.
  ## =======================================
  ## 
  ## Using this block, change stdout style and reset after block.
  when fg != fgDefault:
    setForegroundColor(stdout, fg)
  body
  resetAttributes(stdout)


proc initializeDatabase(dbPath: string) =
  let db = sqlite.open(dbPath, "", "", "")
  newActivity().createTable(db)


proc main*(output: string): int =
  ## Initialize environment
  result = 0  # Always return 0
  addQuitProc(resetAttributes)

  let outputDir = os.absolutePath(output)

  # Display welcome message
  withTerminalStyle(fgGreen):
    echo(r"  _             _    ")
    echo(r" | |_ __ _  ___| |_  ")
    echo(r" | __/ _` |/ __| __| ")
    echo(r" | || (_| | (__| |_  ")
    echo(r"  \__\__,_|\___|\__| ")
    echo(r"=====================")
    echo("Start initialize tact.")
    echo("Files are created into '" & output & "'")
  echo("")

  # Check if config is exists.
  let outputPath = outputDir & DirSep & "tact.cfg"
  if not parentDir(outputPath).existsDir():
    withTerminalStyle(fgRed):
      echo("Output directory must be already exists.")
      return 1
  if outputPath.existsFile():
    withTerminalStyle(fgRed):
      echo("Config file is already exists!")
      return 1

  # Save to file
  var cfg = createConfig(outputDir)
  initializeDatabase(cfg.database)
  cfg.saveTo(outputPath)
  withTerminalStyle(fgGreen):
    echo("Finished initialize!!")
