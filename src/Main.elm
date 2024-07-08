module Main exposing (..)


import Browser
import Browser.Navigation as Nav

import Url

import Element exposing (..)

import Page.Home as Home

import Route


type Model 
  = NotFound Nav.Key
  | Home Nav.Key Home.Model


type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url
  | HomeMsg Home.Msg


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


init : () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init _ url key = 
  updateUrl url ( NotFound key )


updateUrl : Url.Url -> Model -> ( Model, Cmd Msg )
updateUrl url model =
  let
      key = toKey model
  in
  case Route.fromUrl url of
    Just Route.Home ->
      updateWith (Home key) HomeMsg Home.init

    Nothing ->
      ( NotFound key, Cmd.none )


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg ( subModel, subCmd ) =
  ( toModel subModel 
  , Cmd.map toMsg subCmd
  )


view : Model -> Browser.Document Msg
view model = 
  { title = "Kaspeti" 
  , body = 
    [ layout [] <| 
        case model of
          NotFound _ ->
            text "404 Not Found"

          Home _ homeModel ->
            map HomeMsg (Home.view homeModel)
    ]
  }


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case (msg, model) of
    (LinkClicked urlRequest, _) ->
      case urlRequest of
        Browser.Internal url ->
          let
              key = toKey model
          in
          ( model, Nav.pushUrl key (Url.toString url) )

        Browser.External href ->
          ( model, Nav.load href )

    (UrlChanged url, _) ->
      updateUrl url model

    (HomeMsg subMsg, Home key homeModel) ->
      updateWith (Home key) HomeMsg (Home.update subMsg homeModel)

    (_, _) ->
      ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


toKey : Model -> Nav.Key
toKey model = 
  case model of
    NotFound k -> k
    Home k _ -> k
