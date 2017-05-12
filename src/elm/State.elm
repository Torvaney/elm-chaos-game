module State exposing (init, update, subscriptions)


-- Module for the initial state of the app,
-- the supscriptions and the update function

import Random
import Array

import Types exposing (..)


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )


initModel : Model
initModel =
  { traceHistory = []
  , activeTrace = Coord 225 125
  , attractors =
      [ Coord 50 300
      , Coord 225 50
      , Coord 400 300
      ]
  , fraction = 0.5
  }

-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      Next ->
        ( model
        , sendTraceMsg model
        )

      NextN n ->
        ( model
        , sendTraceMsg model |>
            List.repeat n |>
            Cmd.batch
        )

      AddTrace target ->
        ( addNextTrace target model
        , Cmd.none
        )

      Clear ->
        ( clearModel model
        , Cmd.none
        )


sendTraceMsg : Model -> Cmd Msg
sendTraceMsg model =
  List.length model.attractors |>
      Random.int 0 |>
      Random.generate AddTrace


getTarget : Int -> Model -> Maybe Coord
getTarget target model =
  Array.fromList model.attractors |>
    Array.get target


midpoint : Float -> Coord -> Maybe Coord -> Coord
midpoint fraction p1 p2 =
  let
    targetPoint = Maybe.withDefault p1 p2
  in
    { x = (p1.x + targetPoint.x) * fraction
    , y = (p1.y + targetPoint.y) * fraction
    }


nextTrace : Int -> Model -> Coord
nextTrace target model =
  midpoint model.fraction model.activeTrace ( getTarget target model )


addNextTrace : Int -> Model -> Model
addNextTrace target model =
  { model
  | traceHistory = model.traceHistory ++ [ model.activeTrace ]
  , activeTrace = nextTrace target model
  }


clearModel : Model -> Model
clearModel model =
  { model
  | traceHistory = []
  }

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [
        ]
