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
        layout [] (Element.column [ centerX, width fill ] 
          [ navigation model
          , mainFromPath model
          ])
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


mainFromPath : Model -> Element msg
mainFromPath model =
  case model.url.path of
    "/me" ->
      paragraph [ centerX ] [text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ex enim, luctus quis ultricies eget, laoreet vitae ex. In mattis eros ex, id sagittis ligula gravida ac. Praesent ut scelerisque justo. Etiam ut semper elit, nec venenatis nunc. Morbi mollis nisl sit amet sem luctus, at elementum sapien sagittis. Fusce arcu metus, scelerisque ac ligula in, feugiat accumsan massa. Curabitur a arcu condimentum, imperdiet felis in, accumsan sem. Praesent varius ultrices placerat. Vivamus vitae justo cursus, pretium tellus ornare, euismod tortor. In euismod dignissim nibh eu consectetur. Etiam vehicula eu ex et auctor. Aenean a eros cursus, elementum turpis a, placerat metus. Vestibulum interdum, nunc eu commodo ultricies, lorem massa elementum ipsum, nec pulvinar ligula eros in turpis. Integer nulla eros, tristique a faucibus vel, sagittis id turpis. Integer quis sem eget est dignissim cursus. Integer accumsan fermentum condimentum."]
    "/projects" ->
      paragraph [ centerX ] [text "Morbi sed diam imperdiet, pretium justo ac, pharetra purus. Suspendisse in ultrices risus. Sed pulvinar metus urna, id efficitur urna scelerisque egestas. Nulla facilisi. Aliquam facilisis, tortor eget maximus dignissim, metus leo efficitur ante, at consectetur odio nisl sit amet quam. Nullam vitae lorem nisi. Mauris aliquam pharetra neque ut pellentesque. Sed metus quam, facilisis non gravida ac, faucibus non purus. In sed libero tortor. Cras eu ipsum a felis mollis convallis. Morbi facilisis sem non eros pellentesque cursus. Vivamus sit amet pulvinar sem. Vivamus et varius dolor. Nullam venenatis velit nulla."]
    "/site" ->
      paragraph [ centerX ] [text "In hac habitasse platea dictumst. Duis accumsan sodales neque, et pellentesque risus pulvinar sit amet. Nam vitae elit vitae dui pulvinar efficitur ac vitae ipsum. Etiam sapien justo, dignissim vitae nulla ac, suscipit aliquam nunc. Ut nec ligula sed libero consequat tempor vel ut libero. Praesent egestas bibendum augue in dictum. Proin fermentum sapien eu lectus sagittis, ut lobortis justo vestibulum. Quisque ut bibendum metus. Sed ut odio et ipsum bibendum porta. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam ultricies interdum finibus. Phasellus id enim porttitor odio porta tempus. Nunc finibus quam quis mauris auctor aliquet. Integer pharetra nec felis vitae bibendum."]
    _ ->
      text "404 not found"


navigation : Model -> Element.Element msg
navigation model =
  Element.row [ padding 10, spacing 15, centerX ]
  [ link ( naviagtionStyle "/me" model )
    { url = "/me"
    , label = text "about me"
    }
  , text "|"
  , link ( naviagtionStyle "/projects" model )
    { url = "/projects"
    , label = text "projects"
    }
  , text "|"
  , link ( naviagtionStyle "/site" model )
    { url = "/site"
    , label = text "this site"
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
  , Font.underline
  ]

