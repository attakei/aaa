## Configuration for pixela
import options
import parsecfg


type
  PixelaConfig* = ref object
    ## Configurations
    username: string
    token: string
    graph: string

proc username*(self: PixelaConfig): string {.inline.} = self.username

proc token*(self: PixelaConfig): string {.inline.} = self.token

proc graph*(self: PixelaConfig): string {.inline.} = self.graph


proc fromDict*(dict: Config): Option[PixelaConfig] =
  ## Load terail config from dict(parsecfg.config).
  let username: string = dict.getSectionValue("pixela", "username")
  let token: string = dict.getSectionValue("pixela", "token")
  let graph: string = dict.getSectionValue("pixela", "graph")
  if username == "" or token == "" or graph == "":
    return none(PixelaConfig)
  return some(PixelaConfig(username: username, token: token, graph: graph))


proc toDict*(self: PixelaConfig, dict: var Config) =
  dict.setSectionKey("pixela", "username", self.username)
  dict.setSectionKey("pixela", "token", self.token)
  dict.setSectionKey("pixela", "graph", self.graph)
