module Route exposing (Route(..), fromUrl)


import Url
import Url.Parser as Parser exposing (Parser, oneOf)


type Route
  = Home


parser : Parser (Route -> a) a
parser = 
  oneOf 
  [ Parser.map Home Parser.top ]


fromUrl : Url.Url -> Maybe Route
fromUrl url =
  Parser.parse parser url


