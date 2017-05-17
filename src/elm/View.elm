module View exposing (..)

import Html exposing (Html, div, button, h1, p, hr, a, text, input, br)
import Html.Attributes as Attr
import Html.Attributes exposing (class, height, width, id, href)
import Html.Events exposing (onClick, onInput)
import Svg exposing (svg, circle)
import Svg.Attributes exposing (cx, cy, r, fill, fillOpacity, stroke)
import Markdown
import Random

import Types exposing (..)
import State exposing (getAttractors)


drawCanvas model =
  svg [ width <| 500
      , height <| 400
      , id "pitchSvg"
      ]
      ( ( List.map drawTrace model.traceHistory ) ++
        ( List.map drawAttractor (getAttractors model) ) ++
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
                          , onClick ( NextN 25 )
                          ] [ text "Next 25" ]
                      , a [ class "btn"
                          , href "#!"
                          , onClick ( NextN 250 )
                          ] [ text "Next 250" ]
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
          , nSlider model
          , fractionSlider model
          , Markdown.toHtml [ class "text-left" ] appendixText
          ]
    , divN 1
    ]


divN : Int -> Html msg
divN n =
  div [ class ("col-md-" ++ (toString n)) ] []


-- User input

nSlider model =
    div []
    [ text "Number of attractors"
    , br [] []
    , input
      [ Attr.type_ "range"
      , Attr.min <| toString 3
      , Attr.max <| toString 12
      , Attr.step <| toString 1
      , Attr.value <| toString <| model.nAttractors
      , onInput NumAttractors
      ] []
    , br [] []
    , text <| toString <| model.nAttractors
    , br [] []
    ]

fractionSlider model =
    div []
    [ text "Trace fraction"
    , br [] []
    , input
      [ Attr.type_ "range"
      , Attr.min <| toString 0
      , Attr.max <| toString 1
      , Attr.step <| toString 0.05
      , Attr.value <| toString <| model.fraction
      , onInput ChangeFraction
      ] []
    , br [] []
    , text <| toString <| model.fraction
    , br [] []
    ]


-- Draw the points


drawCircle fillColour strokeColour radius alpha point =
  circle [ cx (toString point.x)
         , cy (toString point.y)
         , r <| toString radius
         , fill fillColour
         , fillOpacity <| toString alpha
         , stroke strokeColour
         ] []


drawActiveTrace =
  drawCircle "#45ccfe" "#224593" 4 1.0


drawTrace =
  drawCircle "#224593" "none" 1 0.6


drawAttractor =
  drawCircle "#224593" "#10224b" 9 1.0


-- TEXT

headerText = "Chaos game"


introText = """
The algorithm goes like this:
  1. Pick a target point (large circles) at random
  2. Go a fraction of the way between the current position and the target position
  3. Mark the new point (small circle)
  4. Repeat from `1`

Do you see a pattern emerge?

You can vary both the number of target points and the fraction traversed
with the slider at the bottom.
"""


appendixText = """
Inspired by [Numberphile](https://www.youtube.com/watch?v=kbKtFN71Lfs).

Source code [on github](https://github.com/Torvaney/elm-chaos-game).
"""
