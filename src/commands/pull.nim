## "pull" sub command behavior
## ===========================
## 
## "pull" command collect activites some services of configured.
## 
## If you want to know arguments in command, see ``main()``
import "../config"
import "../core/types/activity"


proc main*(config: string): int =
  ## Collect activities from services
  let cfg = loadConfig(config)
  var acts: seq[Activity] = @[]

  # Display result
  echo($len(acts) & " activities")
  discard cfg
  return 0
  