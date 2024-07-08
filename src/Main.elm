module Main exposing (..)


import Browser
import Browser.Navigation as Nav

import Url

import Element exposing (..)
import Element.Font as Font

import Page.Home as Home
import Page.Me as Me
import Page.Projects as Projects
import Page.Site as Site

import Route


type Model 
  = NotFound Nav.Key
  | Home Nav.Key Home.Model
  | Me Nav.Key Me.Model
  | Projects Nav.Key Projects.Model
  | Site Nav.Key Site.Model


type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url
  | HomeMsg Home.Msg
  | MeMsg Me.Msg
  | ProjectsMsg Projects.Msg
  | SiteMsg Site.Msg


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

    Just Route.Me ->
      updateWith (Me key) MeMsg Me.init

    Just Route.Projects ->
      updateWith (Projects key) ProjectsMsg Projects.init

    Just Route.Site ->
      updateWith (Site key) SiteMsg Site.init

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
    [ layout [] (column [] 
      [ navigation model
      , case model of
          NotFound _ ->
            text "404 Not Found"

          Home _ homeModel ->
            map HomeMsg (Home.view homeModel)

          Me _ meModel ->
            map MeMsg (Me.view meModel)

          Projects _ projectsModel ->
            map ProjectsMsg (Projects.view projectsModel)

          Site _ siteModel ->
            map SiteMsg (Site.view siteModel)
      ])
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

    (MeMsg subMsg, Me key meModel) ->
      updateWith (Me key) MeMsg (Me.update subMsg meModel)
      
    (ProjectsMsg subMsg, Projects key projectsModel) ->
      updateWith (Projects key) ProjectsMsg (Projects.update subMsg projectsModel)

    (SiteMsg subMsg, Site key siteModel) ->
      updateWith (Site key) SiteMsg (Site.update subMsg siteModel)

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
    Me k _ -> k
    Projects k _ -> k
    Site k _ -> k


toRoute : Model -> Route.Route
toRoute model = 
  case model of
    NotFound _ -> Route.Home
    Home _ _ -> Route.Home
    Me _ _-> Route.Me
    Projects _ _ -> Route.Projects
    Site _ _ -> Route.Site



navigation : Model -> Element.Element msg
navigation model =
  let 
      currentRoute = toRoute model
  in
  Element.row [ padding 10, spacing 15, centerX ]
  [ link ( naviagtionStyle Route.Home currentRoute )
    { url = "/"
    , label = text "home"
    }
  , text "|"
  , link ( naviagtionStyle Route.Me currentRoute )
    { url = "/me"
    , label = text "about me"
    }
  , text "|"
  , link ( naviagtionStyle Route.Projects currentRoute )
    { url = "/projects"
    , label = text "projects"
    }
  , text "|"
  , link ( naviagtionStyle Route.Site currentRoute )
    { url = "/site"
    , label = text "this site"
    }
  ]


naviagtionStyle : Route.Route -> Route.Route -> List (Attribute msg)
naviagtionStyle linkRoute currentRoute = 
  [ centerX
  , Font.underline
  , if currentRoute == linkRoute then
      Font.color (rgb 0 0.5 0.25)
    else
      Font.color (rgb 0 0 0)
  ]
