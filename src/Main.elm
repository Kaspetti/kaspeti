module Main exposing (..)


import Browser
import Browser.Navigation as Nav

import Url

import Element.Font as Font
import Element exposing (..)


main : Program () Model Msg
main =
  Browser.application {
    init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  , onUrlChange = UrlChanged
  , onUrlRequest = LinkClicked
  }


type alias Model = 
  { key : Nav.Key
  , url : Url.Url
  }



type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url


init : flags -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init _ url key = (Model key url, Cmd.none)


view : Model -> Browser.Document msg
view model = 
  {
    title = "Hello, World",
    body = 
      [
        layout [] (navigation model)
      ]
  }


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    LinkClicked urlRequest ->
      case urlRequest of 
        Browser.Internal url ->
          ( model, Nav.pushUrl model.key (Url.toString url) )

        Browser.External href ->
          ( model, Nav.load href )

    UrlChanged url ->
      ( { model | url = url }
      , Cmd.none
      )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


navigation : Model -> Element.Element msg
navigation model =
  Element.row [ centerX, padding 10, spacing 7 ]
  [ link ( naviagtionStyle "/site1" model )
    { url = "/site1"
    , label = text "/site1"
    }

  , link ( naviagtionStyle "/site2" model )
    { url = "/site2"
    , label = text "/site2"
    }

  , link ( naviagtionStyle "/site3" model )
    { url = "/site3"
    , label = text "/site3"
    }
  ]


naviagtionStyle : String -> Model -> List (Attribute msg)
naviagtionStyle path model = 
  [ centerX
  , Font.color (if model.url.path == path then
      rgb 0 0.25 0.5
    else
      rgb 0 0 0
    )
  ]

