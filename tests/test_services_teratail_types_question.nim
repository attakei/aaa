import strutils
import times
import unittest
import "core/models/activity"
import "services/teratail/types"


const
  FORMAT_AS_TIMESTAMP = initTimeFormat("YYYY-MM-dd HH:mm:ss")


suite "Question object":
  test "As activity":
    let act = newQuestion(
      1, "demo", times.parse("2020-01-01 00:00:00", FORMAT_AS_TIMESTAMP),
    ).toActivity()
    check act.summary().startsWith("teratail.Question") 


suite "Reply object":
  test "As activity":
    let act = newReply(
      1, times.parse("2020-01-01 00:00:00", FORMAT_AS_TIMESTAMP),
    ).toActivity()
    check act.summary().startsWith("teratail.Reply") 
