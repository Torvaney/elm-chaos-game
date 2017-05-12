module View exposing (..)

import Html exposing (Html, div, button, h1, p, hr, a, text)
import Html.Attributes exposing (class, height, width, id, href, downloadAs)
import Html.Events exposing (onClick)
import Svg exposing (svg, circle)
import Svg.Attributes exposing (cx, cy, r, fill, fillOpacity, stroke)
import Markdown
import Random

import Types exposing (..)


drawCanvas model =
  svg [ width <| 500
      , height <| 500
      , id "pitchSvg"
      ]
      ( ( List.map drawTrace model.traceHistory ) ++
        ( List.map drawAttractor model.attractors ) ++
        [ drawActiveTrace model.activeTrace ]
      )



view : Model -> Html Msg
view model =
  div [ class "row"]
    [ divN 1
    , div [ class "col-md-10 text-center" ]
          [ h1 [ class "text-center" ] [ text headerText ]
          , Markdown.toHtml [ class "text-left" ] introText
          , div [ class "row" ]
            [ div [ class "col-md-12" ]
                [ div [ class "btn-group"]
                      [ a [ class "btn btn-primary"
                          , href "#!"
                          , onClick Next
                          ] [ text "Next" ]
                      , a [ class "btn btn-info"
                          , href "#!"
                          , onClick ( NextN 10 )
                          ] [ text "Next 10" ]
                      , a [ class "btn"
                          , href "#!"
                          , onClick ( NextN 100 )
                          ] [ text "Next 100" ]
                      ]
                , div [ class "btn-group button-right"]
                      [ a [ class "btn btn-danger"
                          , href "#!"
                          , onClick Clear
                          ] [ text "Clear" ]
                      ]
                ] ]
          , drawCanvas model
          , hr [] []
          , Markdown.toHtml [ class "text-left" ] appendixText
          ]
    , divN 1
    ]


drawCircle fillColour radius alpha point =
  circle [ cx (toString point.x)
         , cy (toString point.y)
         , r <| toString radius
         , fill fillColour
         , fillOpacity <| toString alpha
         , stroke "black"
         ] []


drawActiveTrace =
  drawCircle "#fade48" 3 1.0


drawTrace =
  drawCircle "#224593" 1 0.2


drawAttractor =
  drawCircle "#224593" 9 1.0


divN : Int -> Html msg
divN n =
  div [ class ("col-md-" ++ (toString n)) ] []


-- TEXT

headerText = "Chaos game"


introText = """
The algorithm goes like this:
  1. Pick a target point (large circle) at random
  2. Go halfway between the current position and the target position
  3. Mark the new point (small circle)
  4. Repeat from `1`

Do you see a pattern emerge?

Inspired by [Numberphile](https://www.youtube.com/watch?v=kbKtFN71Lfs).
"""


appendixText = """
Source code [on github](https://torvaney.github.io/projects/chaosgame).
"""
