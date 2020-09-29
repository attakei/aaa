## API handler module

const
  PRODUCTION_ENDPOINT = "https://teratail.com/api/v1"

type
  ApiClient* = ref object
    ## API control client
    endpoint: string  ## URL endpont (base)


proc endpoint*(self: ApiClient): string {.inline.} = self.endpoint


proc newApiClient*(): ApiClient =
  result = ApiClient(
    endpoint: PRODUCTION_ENDPOINT,
  )

proc newApiClient*(endpoint: string): ApiClient =
  result = ApiClient(
    endpoint: endpoint,
  )
