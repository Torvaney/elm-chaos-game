module State exposing (init, update, subscriptions, getAttractors)


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
  , activeTrace = initOrigin
  , nAttractors = 3
  , fraction = 0.5
  }


initOrigin = Coord 250 200

initRad = -150


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

      NumAttractors nStr ->
        ( { model
          | nAttractors = Result.withDefault 3 <| String.toInt nStr
          } |> clearModel
        , Cmd.none
        )

      ChangeFraction fractionStr ->
        ( { model
          | fraction = Result.withDefault 0.5 <| String.toFloat fractionStr
          } |> clearModel
        , Cmd.none
        )

      Clear ->
        ( clearModel model
        , Cmd.none
        )


sendTraceMsg : Model -> Cmd Msg
sendTraceMsg model =
  model |>
    getAttractors |>
    List.length |>
    (\a -> a - 1) |>
    Random.int 0 |>
    Random.generate AddTrace


getTarget : Int -> Model -> Maybe Coord
getTarget target model =
  model |>
    getAttractors |>
    Array.fromList |>
    Array.get target


midpoint : Float -> Coord -> Maybe Coord -> Coord
midpoint fraction p1 p2 =
  let
    targetPoint = Maybe.withDefault p1 p2
  in
    { x = fraction * p1.x + (1 - fraction) * targetPoint.x
    , y = fraction * p1.y + (1 - fraction) * targetPoint.y
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


getAttractors : Model -> List Coord
getAttractors model =
  let
    angle = 2 * pi / (toFloat model.nAttractors)
  in
    List.map
      (nthCoord initOrigin initRad angle)
      (List.range 0 model.nAttractors)


nthCoord : Coord -> Float -> Float -> Int -> Coord
nthCoord origin rad angle n =
  let
    nF = toFloat n
  in
    { x = origin.x + rad * (sin (nF * angle))
    , y = origin.y + rad * (cos (nF * angle))
    }


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [
        ]
