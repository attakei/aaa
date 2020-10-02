## Activity type struct
import times
import norm/model


const
  FORMAT_AS_TIMESTAMP* = initTimeFormat("YYYY-MM-dd HH:mm:ss")


type Activity* = ref object of Model
  ## Activity of tech actions
  class: string         ## Activity class(for services)
  timestamp: DateTime   ## Activity date
  link: string          ## Referrer of activity
  body: string          ## JSON-formated string of activity body


proc timestamp*(self: Activity): DateTime {.inline.} = self.timestamp


proc newActivity*(class: string, timestamp: DateTime, link: string, body: string): Activity =
  ## Crete new activity object
  result = Activity(
    class: class,
    timestamp: timestamp,
    link: link,
    body: body,
  )


proc cmp*(x, y: Activity): int =
  ## Compare two activities for sorting.
  result = cmp(x.timestamp, y.timestamp)


proc summary*(self: Activity): string =
  ## Short summary of activity (display class and timestamp)
  result = self.class & " at " & self.timestamp.format(FORMAT_AS_TIMESTAMP)
