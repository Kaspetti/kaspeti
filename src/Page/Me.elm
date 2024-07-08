module Page.Me exposing (Model, Msg, init, update, view)

import Element exposing (..)


type alias Model = {}

type Msg = NoOp


init : ( Model, Cmd msg )
init = 
  ({}, Cmd.none)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = ( model, Cmd.none )



view : Model -> Element Msg
view model =
  el [] (text "me")
