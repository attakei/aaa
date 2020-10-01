## Configuration for teratail
import options
import parsecfg


type
  TeratailConfig* = ref object
    ## Configurations
    username: string
    apiKey: Option[string]


proc username*(self: TeratailConfig): string {.inline.} = self.username

proc apiKey*(self: TeratailConfig): Option[string] {.inline.} = self.apiKey


proc fromDict*(dict: Config): Option[TeratailConfig] =
  ## Load terail config from dict(parsecfg.config).
  let username: string = dict.getSectionValue("teratail", "username")
  let apiKey: string = dict.getSectionValue("teratail", "apikey")
  if username == "":
    return none(TeratailConfig)
  elif apiKey == "":
    return some(TeratailConfig(username: username, apiKey: none(string)))
  else:
    return some(TeratailConfig(username: username, apiKey: some(apiKey)))


proc toDict*(self: TeratailConfig, dict: var Config) =
  dict.setSectionKey("teratail", "username", self.username)
  if self.apiKey.isSome:
    dict.setSectionKey("teratail", "apikey", self.apiKey.get())
