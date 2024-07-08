module Page.Site exposing (Model, Msg, init, update, view)

import Element exposing (..)
import Element.Region as Region
import Element.Font as Font


type alias Model = {}

type Msg = NoOp


init : ( Model, Cmd msg )
init = 
  ({}, Cmd.none)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = ( model, Cmd.none )



view : Model -> Element Msg
view model =
  el [ Region.heading 1, Font.size 36, centerX ] (text "Site")
