## API handler module
import httpclient
import json
import times
import "./types"


const
  PRODUCTION_ENDPOINT = "https://teratail.com/api/v1"
  FORMAT_OF_TIMESTMAP = initTimeFormat("yyyy-MM-dd HH:mm:ss")

type
  ApiClient* = ref object
    ## API control client
    endpoint: string  ## URL endpont (base)
  ApiResponse*[T] = ref object
    ## Package of response component
    page: int
    totalPage: int
    items: seq[T]


proc endpoint*(self: ApiClient): string {.inline.} = self.endpoint

proc items*[T](self: ApiResponse[T]): seq[T] {.inline.} = self.items 


proc newApiClient*(): ApiClient =
  result = ApiClient(
    endpoint: PRODUCTION_ENDPOINT,
  )

proc newApiClient*(endpoint: string): ApiClient =
  result = ApiClient(
    endpoint: endpoint,
  )

proc request(self: ApiClient, urlPath: string): JsonNode =
  let client = newHttpClient()
  let resp = client.request(self.endpoint & urlPath, HttpGet)
  return parseJson(resp.body)


proc getQuestions*(self: ApiClient, displayName: string): ApiResponse[Question] =
  result = ApiResponse[Question](items: @[])
  let urlPath = "/users/" & displayName & "/questions"
  let data = self.request(urlPath)
  result.page = data["meta"]["page"].getInt()
  result.totalPage = data["meta"]["total_page"].getInt()
  for q in data["questions"]:
    result.items.add(newQuestion(
      q["id"].getInt(),
      q["title"].getStr(),
      times.parse(q["created"].getStr(), FORMAT_OF_TIMESTMAP),
    ))


proc getReplies*(self: ApiClient, displayName: string): ApiResponse[Reply] =
  result = ApiResponse[Reply](items: @[])
  let urlPath = "/users/" & displayName & "/replies"
  let data = self.request(urlPath)
  result.page = data["meta"]["page"].getInt()
  result.totalPage = data["meta"]["total_page"].getInt()
  for q in data["replies"]:
    result.items.add(newReply(
      q["question_id"].getInt(),
      times.parse(q["created"].getStr(), FORMAT_OF_TIMESTMAP),
    ))
