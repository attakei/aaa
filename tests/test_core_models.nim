import times
import unittest
import norm/sqlite
import "core/models/activity"


suite "Activity compare":
  let act1 = newActivity(
    "Dummy", times.parse("2020-01-01 00:00:00", FORMAT_AS_TIMESTAMP),
    "-", "{}"
  )

  test "Compare - not same":
    let act2 = newActivity(
      "Dummy", times.parse("2020-01-02 00:00:00", FORMAT_AS_TIMESTAMP),
      "-", "{}"
    )
    check cmp(act1, act2) == -1

  test "Compare - same":
    let act2 = newActivity(
      "Dummy", times.parse("2020-01-01 00:00:00", FORMAT_AS_TIMESTAMP),
      "-", "{}"
    )
    check cmp(act1, act2) == -0


suite "Activity summary":
  test "OK":
    let act = newActivity(
      "Dummy", times.parse("2020-01-01 00:00:00", FORMAT_AS_TIMESTAMP),
      "-", "{}"
    )
    check act.summary == "Dummy at 2020-01-01 00:00:00"
