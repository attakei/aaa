## "push" sub command behavior
## ===========================
## 
## "push" command notify stored activites metrics to some services of configured.
## 
## If you want to know arguments in command, see ``main()``
import options
import os
import times
import norm/sqlite
import "../config"
import "../services/pixela/action" as pixela_action


proc main*(config: string, date: string = ""): int =
  ## Collect activities from services
  let cfg = loadConfig(config)

  var targetDate: DateTime
  if date == "":
    targetDate = now()
    targetDate -= 1.days
  else:
    targetDate = parse(date, "yyyy-MM-dd")
    targetDate.hour = 0
    targetDate.minute = 0
    targetDate.second = 0
  echo("Target is " & targetDate.format("yyyy-MM-dd"))

  os.putEnv("DB_HOST", cfg.database)
  withDb:
    if cfg.pixela.isSome:
      echo "Push acts to pixela"
      block:
        let runner = pixela_action.newPixelaRunner(cfg.pixela.get(), db)
        runner.push(targetDate)
  return 0
