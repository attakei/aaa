## API handler module
import marshal
import times
import "../../core/types/activity"


type
  Question* = ref object
    id: int
    title: string
    created: DateTime
  Reply* = ref object
    questionId: int
    created: DateTime


proc newQuestion*(id: int, title: string, created: DateTime): Question =
  result = Question(
    id: id,
    title: title,
    created: created,
  )


proc newReply*(questionId: int, created: DateTime): Reply =
  result = Reply(
    questionId: questionId,
    created: created,
  )


proc toActivity*(self: Question): Activity =
  result = newActivity(
    "teratail.Question",
    self.created,
    "https://teratail.com/questions/" & $self.id,
    $$self,
  )


proc toActivity*(self: Reply): Activity =
  result = newActivity(
    "teratail.Reply",
    self.created,
    "https://teratail.com/questions/" & $self.questionId,
    $$self,
  )
