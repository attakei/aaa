import times
import unittest
import norm/[model,sqlite]
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


suite "Activity saveing":
  setup:
    let db = open(":memory:", "", "", "")
    newActivity().createTable(db)

  test "New record":
    var act = newActivity(
      "Dummy", times.parse("2020-01-01 00:00:00", FORMAT_AS_TIMESTAMP),
      "-", "{}"
    )
    discard act.save(db)
    check act.id == 1

  test "Record override":
    var act1 = newActivity(
      "Dummy", times.parse("2020-01-01 00:00:00", FORMAT_AS_TIMESTAMP),
      "-", "{}"
    )
    discard act1.save(db)
    var act2 = newActivity(
      "Dummy", times.parse("2020-01-01 00:00:00", FORMAT_AS_TIMESTAMP),
      "--", "{}"
    )
    discard act2.save(db)
    check act2.id == 1

  test "Record multi":
    var act1 = newActivity(
      "Dummy", times.parse("2020-01-01 00:00:00", FORMAT_AS_TIMESTAMP),
      "-", "{}"
    )
    discard act1.save(db)
    var act2 = newActivity(
      "Dummy", times.parse("2020-01-01 00:00:01", FORMAT_AS_TIMESTAMP),
      "--", "{}"
    )
    discard act2.save(db)
    var acts = @[newActivity()]
    db.select(acts, "1=1")
    check len(acts) == 2

  test "Record multi from seq":
    var acts: seq[Activity] = @[
      newActivity(
        "Dummy", times.parse("2020-01-01 00:00:00", FORMAT_AS_TIMESTAMP),
        "-", "{}"
      ),
      newActivity(
        "Dummy", times.parse("2020-01-01 00:00:01", FORMAT_AS_TIMESTAMP),
        "-", "{}"
      )
    ]
    for a in acts:
      discard a.save(db)
    var saved = @[newActivity()]
    db.select(saved, "1=1")
    check len(saved) == 2
