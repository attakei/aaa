## API handler module
import httpclient
import json
import times
import "./consts"


const
  DEFAULT_ENDPOINT* = "https://pixe.la/v1"

type
  ApiClient* = ref object
    ## API control client
    endpoint: string  ## URL endpont (base)
    username: string
    token: string
  ApiResponse* = ref object
    isSuccess: bool
    message: string


proc newApiClient*(username: string, token: string): ApiClient =
  result = ApiClient(
    endpoint: DEFAULT_ENDPOINT,
    username: username,
    token: token,
  )


proc request(self: ApiClient, urlPath: string, body: string): ApiResponse =
  let client = newHttpClient()
  client.headers = newHttpHeaders({ "X-USER-TOKEN": self.token })
  let resp = client.request(self.endpoint & urlPath, HttpPost, body)
  let data = parseJson(resp.body)
  return ApiResponse(
    isSuccess: data["isSuccess"].getBool(),
    message: data["message"].getStr(),
  )


proc postPixel*(self: ApiClient, graphId: string, date: DateTime, quantity: int) =
  let urlPath = "/users/" & self.username & "/graphs/" & graphId
  let payload = %*{
    "date": date.format(DATE_FORMAT),
    "quantity": $quantity,
  }
  discard self.request(urlPath, $payload)
