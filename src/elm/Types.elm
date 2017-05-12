module Types exposing (..)


type Msg
    = Next
    | NextN Int
    | Clear
    | AddTrace Int


-- Model types


type alias Coord =
  { x : Float
  , y : Float
  }


type alias Model =
  { traceHistory : List Coord
  , activeTrace : Coord
  , attractors : List Coord
  , fraction : Float
  }
