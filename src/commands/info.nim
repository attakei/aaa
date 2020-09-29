## "info" sub command behavior
import "../meta"


proc main*(): int =
  ## Display config information
  result = 0  # Always return 0
  echo("tact version " & meta.version)
