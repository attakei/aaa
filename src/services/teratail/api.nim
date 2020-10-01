## API handler module
import httpclient
import json
import options
import times
import "./types"


const
  DEFAULT_ENDPOINT* = "https://teratail.com/api/v1"
  FORMAT_OF_TIMESTMAP = initTimeFormat("yyyy-MM-dd HH:mm:ss")

type
  ApiClient* = ref object
    ## API control client
    endpoint: string  ## URL endpont (base)
    apiKey: Option[string]  ## API Key(optional)
  ApiResponse*[T] = ref object
    ## Package of response component
    page: int
    totalPage: int
    items: seq[T]


proc endpoint*(self: ApiClient): string {.inline.} = self.endpoint

proc items*[T](self: ApiResponse[T]): seq[T] {.inline.} = self.items 

proc hasNext*(self: ApiResponse): bool {.inline.} = (self.page < self.totalPage)

proc nextPage*(self: ApiResponse): int {.inline.} = (self.page + 1)


proc newApiClient*(): ApiClient =
  result = ApiClient(
    endpoint: DEFAULT_ENDPOINT,
  )

proc newApiClient*(endpoint: string): ApiClient =
  result = ApiClient(
    endpoint: endpoint,
  )

proc newApiClient*(endpoint: string, apiKey: string): ApiClient =
  result = ApiClient(
    endpoint: endpoint,
    apiKey: some(apiKey),
  )


proc request(self: ApiClient, urlPath: string): JsonNode =
  ## Request to API. If client hase API-key, set to header.
  let client = newHttpClient()
  if self.apiKey.isSome:
    client.headers = newHttpHeaders({ "Authorization": "Bearer " & self.apiKey.get() })
  let resp = client.request(self.endpoint & urlPath, HttpGet)
  return parseJson(resp.body)


proc getQuestions*(self: ApiClient, displayName: string, page: int): ApiResponse[Question] =
  result = ApiResponse[Question](items: @[])
  let urlPath = "/users/" & displayName & "/questions?page=" & $page
  let data = self.request(urlPath)
  result.page = data["meta"]["page"].getInt()
  result.totalPage = data["meta"]["total_page"].getInt()
  for q in data["questions"]:
    result.items.add(newQuestion(
      q["id"].getInt(),
      q["title"].getStr(),
      times.parse(q["created"].getStr(), FORMAT_OF_TIMESTMAP),
    ))


proc getQuestions*(self: ApiClient, displayName: string): ApiResponse[Question] =
  result = self.getQuestions(displayName, 1)


proc getReplies*(self: ApiClient, displayName: string, page: int): ApiResponse[Reply] =
  result = ApiResponse[Reply](items: @[])
  let urlPath = "/users/" & displayName & "/replies?page=" & $page
  let data = self.request(urlPath)
  result.page = data["meta"]["page"].getInt()
  result.totalPage = data["meta"]["total_page"].getInt()
  for q in data["replies"]:
    result.items.add(newReply(
      q["question_id"].getInt(),
      times.parse(q["created"].getStr(), FORMAT_OF_TIMESTMAP),
    ))


proc getReplies*(self: ApiClient, displayName: string): ApiResponse[Reply] =
  result = self.getReplies(displayName, 1)
