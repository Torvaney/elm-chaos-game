module Types exposing (..)


type Msg
    = Next
    | NextN Int
    | AddTrace Int
    | NumAttractors String
    | Clear


-- Model types


type alias Coord =
  { x : Float
  , y : Float
  }


type alias Model =
  { traceHistory : List Coord
  , activeTrace : Coord
  , nAttractors : Int
  , fraction : Float
  }
