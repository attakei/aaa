## Activity type struct
import times
import norm/[model,sqlite]


const
  FORMAT_AS_TIMESTAMP* = initTimeFormat("YYYY-MM-dd HH:mm:ss")


type Activity* = ref object of Model
  ## Activity of tech actions
  class: string         ## Activity class(for services)
  timestamp: DateTime   ## Activity date
  link: string          ## Referrer of activity
  body: string          ## JSON-formated string of activity body


proc timestamp*(self: Activity): DateTime {.inline.} = self.timestamp


proc newActivity*(
  class: string = "",
  timestamp: DateTime = now(),
  link: string = "",
  body: string = "",
): Activity =
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


proc createTable*(self: Activity, db: DbConn) =
  db.createTables(self)


proc add*(self: var Activity, db: DbConn) =
  ## Upsert activity for database
  try:
    let cond = "Activity.class = ? AND Activity.timestamp = ?"
    var fromDb = Activity()
    db.select(fromDb, cond, self.class, self.timestamp)
    self.id = fromDb.id
    db.delete(fromDb)
  except KeyError as err:
    if err.msg != "Record not found":
      raise err
  finally:
    db.insert(self)
