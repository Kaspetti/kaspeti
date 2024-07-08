module Page.Home exposing (Model, Msg, init, update, view)


import Browser

import Element exposing (..)
import Element.Input as Input


type alias Model = { message : String, inputField : String }


type Msg
  = InputChanged String
  | EnterPressed


init : ( Model, Cmd msg )
init = 
  ({ message = "", inputField = "" }, Cmd.none)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of
    InputChanged content ->
      ( { model | inputField = content }, Cmd.none )

    EnterPressed ->
      ( { model | message = model.inputField, inputField = "" }, Cmd.none )



view : Model -> Element Msg
view model =
  row []
  [ el [] (text model.message)
  , Input.multiline []
    { onChange = InputChanged
    , text = model.inputField
    , placeholder = Just ( Input.placeholder [] (text "Write something...") )
    , label = Input.labelHidden "text input"
    , spellcheck = False
    }
  ]
