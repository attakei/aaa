import options
import sequtils
import times
import "./api"
import "./config"
import "./types"
import "../../core/models/activity"


type TeratailRunner* = ref object
  ## Handle endpoint for tact commands
  cfg: TeratailConfig
  apiClient: ApiClient


proc newTeratailRunner*(cfg: TeratailConfig): TeratailRunner =
  let apiClient =
    if cfg.apiKey.isNone:
      newApiClient()
    else:
      newApiClient(
        DEFAULT_ENDPOINT,
        cfg.apiKey.get(),
      )
  result = TeratailRunner(cfg: cfg, apiClient: apiClient)


proc fetch*(self: TeratailRunner, targetDate: DateTime): seq[Activity] =
  ## Fetch activities from teratail.
  let nextDate = targetDate + 1.days

  # Questions
  var questions = newSeq[Activity]()
  block:
    var resp = self.apiClient.getQuestions(self.cfg.username)
    questions = concat(questions, resp.items.mapIt(it.toActivity()))
    while resp.hasNext() and questions[questions.len-1].timestamp > targetDate:
      var resp = self.apiClient.getQuestions(self.cfg.username, resp.nextPage)
      questions = concat(questions, resp.items.mapIt(it.toActivity()))

  # Replies
  var replies = newSeq[Activity]()
  block:
    var resp = self.apiClient.getReplies(self.cfg.username)
    replies = concat(replies, resp.items.mapIt(it.toActivity()))
    while resp.hasNext() and replies[replies.len-1].timestamp > targetDate:
      var resp = self.apiClient.getReplies(self.cfg.username, resp.nextPage)
      replies = concat(replies, resp.items.mapIt(it.toActivity()))

  # Return
  return concat(questions, replies).filterIt(it.timestamp >= targetDate).filterIt(it.timestamp < nextDate)
