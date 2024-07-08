module Route exposing (Route(..), fromUrl)


import Url
import Url.Parser as Parser exposing (Parser, oneOf, s)


type Route
  = Home
  | Me
  | Projects
  | Site


parser : Parser (Route -> a) a
parser = 
  oneOf 
  [ Parser.map Home Parser.top 
  , Parser.map Me (s "me")
  , Parser.map Projects (s "projects")
  , Parser.map Site (s "site")
  ]


fromUrl : Url.Url -> Maybe Route
fromUrl url =
  Parser.parse parser url


