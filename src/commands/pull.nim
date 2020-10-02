## "pull" sub command behavior
## ===========================
## 
## "pull" command collect activites some services of configured.
## 
## If you want to know arguments in command, see ``main()``
import options
import sequtils
import times
import "../config"
import "../core/models/activity"
import "../services/teratail/action" as teratail_action


proc main*(config: string, date: string = ""): int =
  ## Collect activities from services
  let cfg = loadConfig(config)
  var acts: seq[Activity] = @[]

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

  if cfg.teratail.isSome:
    echo "Pull acts from teratail"
    block:
      let runner = teratail_action.newTeratailRunner(cfg.teratail.get())
      acts = concat(acts, runner.fetch(targetDate))
    echo("OK")

  # Display result
  echo($len(acts) & " activities")
  discard cfg
  return 0
  