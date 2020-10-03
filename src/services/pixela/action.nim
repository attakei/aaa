import times
import norm/sqlite
import "./api"
import "./config"
import "../../core/models/activity"


type PixelaRunner* = ref object
  ## Handle endpoint for tact commands
  cfg: PixelaConfig
  apiClient: ApiClient
  db: DbConn


proc newPixelaRunner*(cfg: PixelaConfig, db: DbConn): PixelaRunner =
  let apiClient = newApiClient(
    cfg.username,
    cfg.token,
  )
  result = PixelaRunner(cfg: cfg, apiClient: apiClient, db: db)


proc push*(self: PixelaRunner, targetDate: DateTime) =
  ## Fetch activities from teratail.
  let nextDate = targetDate + 1.days
  var stored = @[newActivity()]
  self.db.select(
    stored,
    "Activity.timestamp >= ? AND Activity.timestamp < ?",
    targetDate,
    nextDate,
  )
  self.apiClient.postPixel(
    self.cfg.graph,
    targetDate,
    len(stored),
  )
